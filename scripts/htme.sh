#!/bin/bash

set -u
set +e

S3_BUCKET="${1}"
S3_FULL_FOLDER="${2}"
TOPIC_NAME="${3}"
S3_MANIFEST_FOLDER="${4}"
S3_MANIFEST_BUCKET="${5}"
HBASE_MASTER_URL="${6}"
MAX_MEMORY_ALLOCATION="${7}"
CORRELATION_ID="${8}"
HTME_SCAN_WIDTH="${9}"
SQS_MESSAGE_ID="${10}"
STATUS_TABLE_NAME="${11}"
START_DATE_TIME="${12}"
END_DATE_TIME="${13}"
SNAPSHOT_SENDER_SQS_QUEUE_URL="${14}"
SNAPSHOT_SENDER_REPROCESS_FILES="${15}"
SNAPSHOT_SENDER_SHUTDOWN_FLAG="${16}"
SNAPSHOT_SENDER_EXPORT_DATE="${17}"
TRIGGER_SNAPSHOT_SENDER="${18}"
BLOCKED_TOPICS="${19}"
RECEIPT_HANDLE="${20}"
SQS_INCOMING_URL="${21}"
SNAPSHOT_TYPE="${22}"
HTME_SHUTDOWN_ON_COMPLETION="${23}"
SNS_TOPIC_ARN_MONITORING="${24}"
SNS_TOPIC_ARN_COMPLETION_INCREMENTAL="${25}"
SNS_TOPIC_ARN_COMPLETION_FULL="${26}"
TRIGGER_ADG="${27}"
PRODUCT_STATUS_TABLE_NAME="${28}"
SQS_MESSAGE_GROUP_ID="${29}"
SEND_TO_RIS="${30}"
SEND_TO_CRE="${31}"
DATA_EGRESS_SQS_QUEUE_URL="${32}"

AWS_PATH=$(which aws)

ENVIRONMENT_NAME="NOT_SET"
if [ -f "/opt/htme/environment" ]; then
    ENVIRONMENT_NAME=$(cat /opt/htme/environment)
fi

APP_VERSION="NOT_SET"
if [ -f "/opt/htme/version" ]; then
    APP_VERSION=$(cat /opt/htme/version)
fi

APPLICATION_NAME="hbase_to_mongo_exporter"
COMPONENT_NAME="jar_file"

# Import the logging functions
source /opt/htme/logging.sh

function log_shell_message() {
    log_htme_message "${1}" "htme.sh" "NOT_SET" "${@:2}" "correlation_id,${CORRELATION_ID}" \
    "sqs_message_id,${SQS_MESSAGE_ID}" "topic_name,${TOPIC_NAME}" \
    "start_date_time,${START_DATE_TIME}" "end_date_time,${END_DATE_TIME}" \
    "dynamodb_status_table_name,${STATUS_TABLE_NAME}" \
    "dynamodb_product_status_table_name,${PRODUCT_STATUS_TABLE_NAME}" \
    "snapshot_sender_sqs_queue_url,${SNAPSHOT_SENDER_SQS_QUEUE_URL}" \
    "snapshot_sender_reprocess_files,${SNAPSHOT_SENDER_REPROCESS_FILES}" \
    "snapshot_sender_shutdown_flag,${SNAPSHOT_SENDER_SHUTDOWN_FLAG}" \
    "snapshot_sender_export_date,${SNAPSHOT_SENDER_EXPORT_DATE}" \
    "trigger_snapshot_sender,${TRIGGER_SNAPSHOT_SENDER}" \
    "receipt_handle,${RECEIPT_HANDLE}" \
    "sqs_incoming_url,${SQS_INCOMING_URL}" \
    "blocked_topics,${BLOCKED_TOPICS}" \
    "snapshot_type,${SNAPSHOT_TYPE}" \
    "sns_topic_arn_monitoring,${SNS_TOPIC_ARN_MONITORING}" \
    "sns_topic_arn_completion_incremental,${SNS_TOPIC_ARN_COMPLETION_INCREMENTAL}" \
    "sns_topic_arn_completion_full,${SNS_TOPIC_ARN_COMPLETION_FULL}" \
    "trigger_adg,${TRIGGER_ADG}" \
    "sqs_message_group_id,${SQS_MESSAGE_GROUP_ID}" \
    "send_to_ris,${SEND_TO_RIS}" \
    "send_to_cre,${SEND_TO_CRE}" \
    "data_egress_sqs_queue_url,${DATA_EGRESS_SQS_QUEUE_URL}"
}

function get_status_from_dynamodb() {
    response=$(${AWS_PATH} dynamodb get-item --table-name "${STATUS_TABLE_NAME}" \
        --key "{\"CorrelationId\":{\"S\":\"${CORRELATION_ID}\"},\"CollectionName\":{\"S\":\"${TOPIC_NAME}\"}}")
    echo "$response" | jq -r .'Item.CollectionStatus.S'
}

function update_dynamo_topic_with_status() {
    local NEW_STATUS=${1}
    ${AWS_PATH} dynamodb update-item --table-name "${STATUS_TABLE_NAME}" \
        --key "{\"CorrelationId\":{\"S\":\"${CORRELATION_ID}\"},\"CollectionName\":{\"S\":\"${TOPIC_NAME}\"}}" \
        --update-expression "SET CollectionStatus = :s" \
        --expression-attribute-values "{\":s\": {\"S\":\"${NEW_STATUS}\"}}"
}

function reset_topic_counts_in_dynamo() {
    ${AWS_PATH} dynamodb update-item --table-name "${STATUS_TABLE_NAME}" \
        --key "{\"CorrelationId\":{\"S\":\"${CORRELATION_ID}\"},\"CollectionName\":{\"S\":\"${TOPIC_NAME}\"}}" \
        --update-expression "SET FilesExported = :a, FilesSent = :b, FilesReceived = :c" \
        --expression-attribute-values "{\":a\": {\"N\":\"0\"}, \":b\": {\"N\":\"0\"}, \":c\": {\"N\":\"0\"}}"
}

function verify_and_call_reset_dynamo_topic_counts() {
    log_shell_message "Starting topic count reset in dynamo db"
    reset_topic_counts_in_dynamo
    log_shell_message "Topic count has been reset in DynamoDB"
}

function verify_and_call_update_dynamo_topic_status() {
    local STATUS_TO_UPDATE="${1}"

    log_shell_message "Starting write to dynamo db" "status,${STATUS_TO_UPDATE}"
    update_dynamo_topic_with_status "${STATUS_TO_UPDATE}"
    log_shell_message "Collection status has been written to DynamoDB" "status,${STATUS_TO_UPDATE}"
}

function resend_sqs_message_for_failed_topic() {
    SQS_OUTGOING_MESSAGE=$(jq -n "{\"run-export\": \"true\", \
        \"correlation-id\": \"${CORRELATION_ID}\", \
        \"topic-name\": \"${TOPIC_NAME}\", \
        \"start-date-time\": \"${START_DATE_TIME}\", \
        \"end-date-time\": \"${END_DATE_TIME}\", \
        \"htme-shutdown-on-completion\": \"${HTME_SHUTDOWN_ON_COMPLETION}\", \
        \"ss-shutdown-on-completion\": \"${SNAPSHOT_SENDER_SHUTDOWN_FLAG}\", \
        \"s3-full-folder\": \"${S3_FULL_FOLDER}\", \
        \"export-date\": \"${SNAPSHOT_SENDER_EXPORT_DATE}\", \
        \"run-ss-after-export\": \"${TRIGGER_SNAPSHOT_SENDER}\", \
        \"ss-reprocess-files\": \"true\", \
        \"trigger-adg\": \"${TRIGGER_ADG}\", \
        \"snapshot-type\": \"${SNAPSHOT_TYPE}\", \
        \"send-to-ris\": \"${SEND_TO_RIS}\", \
         \"send-to-cre\": \"${SEND_TO_CRE}\"}")

    log_shell_message "Sending message to SQS to restart failed topic" "sqs_outgoing_message,${SQS_OUTGOING_MESSAGE}"
    ${AWS_PATH} sqs send-message --queue-url "${SQS_INCOMING_URL}" --message-body "${SQS_OUTGOING_MESSAGE}" --message-group-id "${SQS_MESSAGE_GROUP_ID}"
    aws_sqs_result=$?
    log_shell_message "Sent message to SQS to restart topic" "aws_sqs_result,${aws_sqs_result}" "sqs_outgoing_message,${SQS_OUTGOING_MESSAGE}"
}

function retry_if_topic_failed() {
    status=$(get_status_from_dynamodb)
    log_shell_message "Collection status" "collection_status,${status}" "receipt_handle,${RECEIPT_HANDLE}"

    # Do not retry for blocked topics or table unavailable
    if [[ "${status}" == "Export_Failed" ]]; then
        verify_and_call_reset_dynamo_topic_counts
        resend_sqs_message_for_failed_topic
    fi
}

# Unset proxy vars inherited from wrapper
unset http_proxy
unset HTTP_PROXY
unset https_proxy
unset HTTPS_PROXY
unset no_proxy
unset NO_PROXY

if [[ "${MAX_MEMORY_ALLOCATION}" == "NOT_SET" ]]; then
    log_shell_message "Defaulting to no max memory allocation" "requested_value,${MAX_MEMORY_ALLOCATION}"
    MAX_MEMORY_ALLOCATION=""
else
    log_shell_message "Setting max memory allocation" "max_memory_allocation,${MAX_MEMORY_ALLOCATION}"
fi

if [[ -n "${START_DATE_TIME}" ]]; then
    log_shell_message "Setting scan start date time" "scan_start_date_time,${START_DATE_TIME}"
    START_DATE_TIME_ARGUMENT="--scan.time.range.start=${START_DATE_TIME} "
fi

if [[ -n "${END_DATE_TIME}" ]]; then
    log_shell_message "Setting scan end date time" "scan_end_date_time,${END_DATE_TIME}"
    END_DATE_TIME_ARGUMENT="--scan.time.range.end=${END_DATE_TIME} "
fi

run_htme_jar() {
    log_shell_message "Starting topic"

    verify_and_call_update_dynamo_topic_status "Exporting"

    TRIGGER_ADG_BOOLEAN=false
    if [[ "${TRIGGER_ADG}" == *"true"*  ]]; then
        log_shell_message "Setting trigger ADG to true" "trigger_adg,${TRIGGER_ADG}" "trigger_adg_boolean,${TRIGGER_ADG_BOOLEAN}"
        TRIGGER_ADG_BOOLEAN=true
    fi

    SEND_TO_RIS_BOOLEAN=false
    if [[ "${SEND_TO_RIS}" == *"true"*  ]]; then
        log_shell_message "Setting send.to.ris to true" "send_to_ris,${SEND_TO_RIS}" "send_to_ris_boolean,${SEND_TO_RIS_BOOLEAN}"
        SEND_TO_RIS_BOOLEAN=true
    fi

    SEND_TO_CRE_BOOLEAN=false
    if [[ "${SEND_TO_CRE}" == *"true"*  ]]; then
        log_shell_message "Setting send.to.cre to true" "send_to_cre,${SEND_TO_CRE}" "send_to_CRE_boolean,${SEND_TO_CRE_BOOLEAN}"
        SEND_TO_CRE_BOOLEAN=true
    fi

    # This can not have double quotes in the command, hence the disable for shellcheck
    #shellcheck disable=SC2086
    java ${MAX_MEMORY_ALLOCATION} -Denvironment="${ENVIRONMENT_NAME}" \
        -Dapplication="${APPLICATION_NAME}" \
        -Dapp_version="${APP_VERSION}" \
        -Dcomponent="${COMPONENT_NAME}" \
        -Dtopic_name="${TOPIC_NAME}" \
        -Dcorrelation_id="${CORRELATION_ID}" \
        -Dsqs_message_id="${SQS_MESSAGE_ID}" \
        -jar /opt/htme/htme.jar ${START_DATE_TIME_ARGUMENT}${END_DATE_TIME_ARGUMENT}\
        --hbase.zookeeper.quorum="${HBASE_MASTER_URL}" \
        --aws.region="${AWS_DEFAULT_REGION}" \
        --topic.name="${TOPIC_NAME}" \
        --s3.bucket="${S3_BUCKET}" \
        --s3.prefix.folder="${S3_FULL_FOLDER}" \
        --s3.manifest.prefix.folder="${S3_MANIFEST_FOLDER}/${SNAPSHOT_TYPE}" \
        --s3.manifest.bucket="${S3_MANIFEST_BUCKET}" \
        --scan.width="${HTME_SCAN_WIDTH}" \
        --dynamodb.status.table.name="${STATUS_TABLE_NAME}" \
        --dynamodb.product.status.table.name="${PRODUCT_STATUS_TABLE_NAME}" \
        --snapshot.sender.sqs.queue.url="${SNAPSHOT_SENDER_SQS_QUEUE_URL}" \
        --snapshot.sender.reprocess.files="${SNAPSHOT_SENDER_REPROCESS_FILES}" \
        --snapshot.sender.shutdown.flag="${SNAPSHOT_SENDER_SHUTDOWN_FLAG}" \
        --snapshot.sender.export.date="${SNAPSHOT_SENDER_EXPORT_DATE}" \
        --trigger.snapshot.sender="${TRIGGER_SNAPSHOT_SENDER}" \
        --blocked.topics="${BLOCKED_TOPICS}" \
        --snapshot.type="${SNAPSHOT_TYPE}" \
        --topic.arn.monitoring="${SNS_TOPIC_ARN_MONITORING}" \
        --topic.arn.completion.incremental="${SNS_TOPIC_ARN_COMPLETION_INCREMENTAL}" \
        --topic.arn.completion.full="${SNS_TOPIC_ARN_COMPLETION_FULL}" \
        --trigger.adg=${TRIGGER_ADG_BOOLEAN} \
        --send.to.ris=${SEND_TO_RIS_BOOLEAN} \
        --send.to.cre=${SEND_TO_CRE_BOOLEAN} \
        --data.egress.sqs.queue.url="${DATA_EGRESS_SQS_QUEUE_URL}" \
        --spring.config.location="/opt/htme/config/application.properties";

    local HTME_EXIT_CODE=$?

    if [[ ${HTME_EXIT_CODE} == 0 ]]; then
        log_shell_message "Completed topic" "topic_status,Successful" "htme_exit_code,${HTME_EXIT_CODE}" "receipt_handle,${RECEIPT_HANDLE}"
    else
        log_shell_message "Completed topic" "topic_status,Failed" "htme_exit_code,${HTME_EXIT_CODE}" "receipt_handle,${RECEIPT_HANDLE}"
        retry_if_topic_failed
    fi
}

run_htme_jar >> "/var/log/htme/htme.log" 2>&1
