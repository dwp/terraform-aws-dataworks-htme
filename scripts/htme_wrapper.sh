#!/bin/bash

set -u

# Import the logging functions
source /opt/htme/logging.sh

function log_wrapper_message() {
    log_htme_message "${1}" "htme_wrapper.sh" "${PID}" "${@:2}" "correlation_id,${CORRELATION_ID}" \
    "sqs_message_id,${SQS_MESSAGE_ID}" "topic_name,${TOPIC_NAME}" "instance_id,${INSTANCE_ID}" \
    "htme_shutdown_on_completion,${SHUTDOWN_HTME}" "sqs_queue_check_count,${SQS_QUEUE_CHECK_COUNT}" \
    "sqs_queue_seconds_without_message,${SQS_QUEUE_SECONDS_WITHOUT_MESSAGE}" "export_date,${EXPORT_DATE}" \
    "ss_shutdown_on_completion,${SHUTDOWN_SS}" "s3_full_folder,${S3_FULL_FOLDER}" "run_export,${RUN_EXPORT}" \
    "start_date_time,${START_DATE_TIME}" "end_date_time,${END_DATE_TIME}" "trigger_snapshot_sender,${TRIGGER_SNAPSHOT_SENDER}" \
    "ss_reprocess_files,${REPROCESS_FILES}" "snapshot_type,${SNAPSHOT_TYPE}" "trigger_adg,${TRIGGER_ADG}" \
    "sqs_message_group_id,${SQS_MESSAGE_GROUP_ID}" "send_to_ris,${SEND_TO_RIS}"
    "sqs_message_group_id,${SQS_MESSAGE_GROUP_ID}" "send_to_cre,${SEND_TO_CRE}"
}

function detach_from_asg() {
    local target_asg_name=$1
    local local_instance_id=$2

    log_wrapper_message "Triggering detach from ASG" "instance_id,${local_instance_id}" \
        "target_asg_name,${target_asg_name}"
    set +e
    detachment_activity_results=$(${AWS_PATH} autoscaling detach-instances --instance-ids "${local_instance_id}" \
        --auto-scaling-group-name "${target_asg_name}" --should-decrement-desired-capacity)
    aws_call_result=$?
    set -e

    detach_activity_id=$(echo "${detachment_activity_results}" | jq -r '.Activities[0].ActivityId')
    export detachment_activity_id="$detach_activity_id"
    log_wrapper_message "Detach from ASG triggered" "aws_call_result,${aws_call_result}" \
        "instance_id,${local_instance_id}" "target_asg_name,${target_asg_name}" \
        "detachment_activity_id,${detachment_activity_id}"
}

function shutdown_after_successful_detachment() {
    log_wrapper_message "Waiting for detachment to succeed" \
        "detachment_activity_id,${detachment_activity_id}"

    limit=601
    interval=5
    time_passed=0
    detachment_activity_status="NOT_SET"

    while [[ "${detachment_activity_status}" != 'Successful' ]] && [[ ${time_passed} -lt ${limit} ]]; do
        set +e
        detachment_activity_status=$(${AWS_PATH} autoscaling describe-scaling-activities \
            --activity-ids "${detachment_activity_id}" | jq -r '.Activities[0].StatusCode')
        aws_call_result=$?
        set -e

        log_wrapper_message "Current detachment status" "detachment_activity_status,${detachment_activity_status}" \
            "detachment_activity_id,${detachment_activity_id}" "aws_call_result,${aws_call_result}" \
            "time_passed,${time_passed}"

        time_passed=$((time_passed + interval))
        sleep ${interval}
    done

    if [[ "${detachment_activity_status}" == 'Successful' ]]; then
        log_wrapper_message "Detachment successful, shutdown proceeding" \
            "detachment_activity_status,${detachment_activity_status}" \
            "detachment_activity_id,${detachment_activity_id}" "aws_call_result,${aws_call_result}" \
            "time_passed,${time_passed}"
        shutdown_vm
    else
        log_wrapper_message "Detachment timed out so not shutting down" \
            "detachment_activity_status,${detachment_activity_status}" \
            "detachment_activity_id,${detachment_activity_id}" "aws_call_result,${aws_call_result}" \
            "time_passed,${time_passed}"
    fi
}

function shutdown_vm() {
    log_wrapper_message "Shutting down instance"

    # Sleeping here to allow the logs to flush as there is a one second delay
    sleep 5

    sudo /sbin/shutdown -h now
}

function reset_message_specific_vars() {
    new_value=$1

    export CORRELATION_ID="${new_value}"
    export SQS_MESSAGE_ID="${new_value}"
    export TOPIC_NAME="${new_value}"
    export EXPORT_DATE="${new_value}"
    export S3_FULL_FOLDER="${new_value}"
    export SHUTDOWN_SS="${new_value}"
    export RECEIPT_HANDLE="${new_value}"
    export RUN_EXPORT="${new_value}"
    export TRIGGER_SNAPSHOT_SENDER="${new_value}"
    export SNAPSHOT_TYPE="${new_value}"

    export START_DATE_TIME=""
    export END_DATE_TIME=""
    export REPROCESS_FILES=""
    export TRIGGER_ADG=""
    export SEND_TO_RIS=""
    export SEND_TO_CRE=""
}

function set_boot_launch_template_variables() {
    set +e
    boot_name=$(${AWS_PATH} autoscaling describe-auto-scaling-groups --auto-scaling-group-names "${ASG_NAME}" | jq .AutoScalingGroups[0].Instances | jq -r ".[] | select(.InstanceId==\"${INSTANCE_ID}\") | .LaunchTemplate.LaunchTemplateName")
    boot_version=$(${AWS_PATH} autoscaling describe-auto-scaling-groups --auto-scaling-group-names "${ASG_NAME}" | jq .AutoScalingGroups[0].Instances | jq -r ".[] | select(.InstanceId==\"${INSTANCE_ID}\") | .LaunchTemplate.Version")
    export BOOT_LAUNCH_TEMPLATE_NAME="$boot_name"
    export BOOT_LAUNCH_TEMPLATE_VERSION="$boot_version"
    set -e

    log_wrapper_message "Boot launch template version retrieved" "launch_template_name,${BOOT_LAUNCH_TEMPLATE_NAME}" \
        "boot_launch_template_version,${BOOT_LAUNCH_TEMPLATE_VERSION}"
}

function check_latest_template_and_restart_if_not_on_latest() {
    set +e
    latest_version=$(${AWS_PATH} ec2 describe-launch-templates --launch-template-names "${BOOT_LAUNCH_TEMPLATE_NAME}" | jq -r ".LaunchTemplates[0].LatestVersionNumber")
    export LATEST_LAUNCH_TEMPLATE_VERSION="$latest_version"
    set -e

    log_wrapper_message "Latest launch template version retrieved" "launch_template_name,${BOOT_LAUNCH_TEMPLATE_NAME}" \
        "latest_launch_template_version,${LATEST_LAUNCH_TEMPLATE_VERSION}"

    if [[ -z "${LATEST_LAUNCH_TEMPLATE_VERSION}" ]] || [[ -z "${BOOT_LAUNCH_TEMPLATE_VERSION}" ]]; then
        log_wrapper_message "Could not retrieve one or both launch template versions so not performing restart check" \
            "launch_template_name,${BOOT_LAUNCH_TEMPLATE_NAME}" \
            "latest_launch_template_version,${LATEST_LAUNCH_TEMPLATE_VERSION}" \
            "boot_launch_template_version,${BOOT_LAUNCH_TEMPLATE_VERSION}"
    elif [[ "${LATEST_LAUNCH_TEMPLATE_VERSION}" != "${BOOT_LAUNCH_TEMPLATE_VERSION}" ]]; then
        log_wrapper_message "Shutting down as launch template has been updated" "launch_template_name,${BOOT_LAUNCH_TEMPLATE_NAME}" \
            "latest_launch_template_version,${LATEST_LAUNCH_TEMPLATE_VERSION}" \
            "boot_launch_template_version,${BOOT_LAUNCH_TEMPLATE_VERSION}"
        shutdown_vm
        exit 0
    fi
}

function delete_sqs_message() {
    sqs_message_handle="${1}"
    set +e
    ${AWS_PATH} sqs delete-message --queue-url "${SQS_INCOMING_URL}" --receipt-handle "${sqs_message_handle}"
    aws_sqs_result=$?
    log_wrapper_message "Deleted SQS message" "aws_sqs_result,${aws_sqs_result}" "receipt_handle,${sqs_message_handle}"
    set -e
}

reset_message_specific_vars "NO_MESSAGE_YET"

initial_pid="NOT_SET"
export PID="$initial_pid"

SQS_QUEUE_CHECK_COUNT=0
SQS_QUEUE_SECONDS_WITHOUT_MESSAGE=0
SQS_MESSAGES_PROCESSED_COUNT=0
MINIMUM_SHUTDOWN_DELAY=900
SLEEP_SECONDS=4

SHUTDOWN_HTME="NOT_SET"
INSTANCE_ID="NOT_SET"
AWS_PATH=$(which aws)

S3_BUCKET="${1}"
SQS_OUTGOING_URL="${2}"
INSTANCE_ID="${3}"
SQS_INCOMING_URL="${4}"
FULL_PROXY="${5}"
FULL_NO_PROXY="${6}"
S3_MANIFEST_FOLDER="${7}"
S3_MANIFEST_BUCKET="${8}"
ASG_NAME="${9}"
HBASE_MASTER_URL="${10}"
MAX_MEMORY_ALLOCATION="${11}"
HTME_SCAN_WIDTH="${12}"
STATUS_TABLE_NAME="${13}"
BLOCKED_TOPICS="${14}"
SNS_TOPIC_ARN_MONITORING="${15}"
SNS_TOPIC_ARN_COMPLETION_INCREMENTAL="${16}"
SNS_TOPIC_ARN_COMPLETION_FULL="${17}"
PRODUCT_STATUS_TABLE_NAME="${18}"
SQS_MESSAGE_GROUP_ID="${19}"
DATA_EGRESS_SQS_URL="${20}"

region_default=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | cut -d'"' -f4)
export AWS_DEFAULT_REGION="$region_default"
export http_proxy="${FULL_PROXY}"
export HTTP_PROXY="${FULL_PROXY}"
export https_proxy="${FULL_PROXY}"
export HTTPS_PROXY="${FULL_PROXY}"
export no_proxy="${FULL_NO_PROXY}"
export NO_PROXY="${FULL_NO_PROXY}"

log_wrapper_message "Proxy variables set correctly" "http_proxy,${http_proxy}" "no_proxy,${no_proxy}"
log_wrapper_message "Checking sqs for new messages on queue" "queue_url,${SQS_INCOMING_URL}"

set_boot_launch_template_variables

while true; do
    SQS_QUEUE_CHECK_COUNT=$((SQS_QUEUE_CHECK_COUNT + 1))

    if ! ((SQS_QUEUE_CHECK_COUNT % 15 )) ; then
        # Only log this every minute so as not to spam the logs
        log_wrapper_message "Checking sqs for new messages on queue" "queue_url,${SQS_INCOMING_URL}"
    fi

    # Get the number of available messages on the queue
    set +e
    AVAILABLE_MESSAGE_COUNT=$(${AWS_PATH} sqs get-queue-attributes --queue-url "${SQS_INCOMING_URL}" \
    --attribute-names ApproximateNumberOfMessages | jq -r .Attributes.ApproximateNumberOfMessages)
    set -e

    # Only do any work if there are messages to receive
    if [[ -n "${AVAILABLE_MESSAGE_COUNT}" ]] && [[ ${AVAILABLE_MESSAGE_COUNT} -gt 0 ]] ; then
        log_wrapper_message "Messages on queue to be received, so checking launch template version" \
        "queue_url,${SQS_INCOMING_URL}" "available_message_count,${AVAILABLE_MESSAGE_COUNT}"

        # Ensure you are processing messages on the latest launch template version
        check_latest_template_and_restart_if_not_on_latest

        set +e
        MESSAGE=$(${AWS_PATH} sqs receive-message --queue-url "${SQS_INCOMING_URL}" --attribute-names All)
        set -e

        # Check still needed as small possibility in the meantime, the available messages have already been taken
        if [[ -n "${MESSAGE}" ]]; then
            SQS_QUEUE_SECONDS_WITHOUT_MESSAGE=0 #Reset as we have received a new message
            SQS_MESSAGES_PROCESSED_COUNT=$((SQS_MESSAGES_PROCESSED_COUNT + 1)) #Increase execution count as htme has been executed

            RECEIPT_HANDLE=$(echo "${MESSAGE}" | jq -r '.Messages[].ReceiptHandle')
            SQS_MESSAGE_ID=$(jq -r '.Messages[].MessageId' <<< "${MESSAGE}")
            BODY=$(echo "${MESSAGE}" | jq -r '.Messages[].Body')
            CORRELATION_ID=$(echo "${BODY}" | jq -r '."correlation-id"')
            TOPIC_NAME=$(echo "${BODY}" | jq -r '."topic-name"')
            START_DATE_TIME=$(echo "${BODY}" | jq -r '."start-date-time" // empty')
            END_DATE_TIME=$(echo "${BODY}" | jq -r '."end-date-time" // empty')

            log_wrapper_message "Received message from SQS queue" "queue_url,${SQS_INCOMING_URL}" \
                "receipt_handle,${RECEIPT_HANDLE}"

            RUN_EXPORT=$(echo "${BODY}" | jq -r '."run-export"')
            SHUTDOWN_HTME=$(echo "${BODY}" | jq -r '."htme-shutdown-on-completion"')
            SHUTDOWN_SS=$(echo "${BODY}" | jq -r '."ss-shutdown-on-completion"')
            S3_FULL_FOLDER=$(echo "${BODY}" | jq -r '."s3-full-folder"')
            EXPORT_DATE=$(echo "${BODY}" | jq -r '."export-date"')
            TRIGGER_SNAPSHOT_SENDER=$(echo "${BODY}" | jq -r '."run-ss-after-export"')
            SNAPSHOT_TYPE=$(echo "${BODY}" | jq -r '."snapshot-type"')
            REPROCESS_FILES=$(echo "${BODY}" | jq -r '."ss-reprocess-files" // empty')
            TRIGGER_ADG=$(echo "${BODY}" | jq -r '."trigger-adg" // empty')
            SEND_TO_RIS=$(echo "${BODY}" | jq -r '."send-to-ris" // empty')
            SEND_TO_CRE=$(echo "${BODY}" | jq -r '."send-to-cre" // empty')

            if [[ "${REPROCESS_FILES}" != *"true"* ]]; then
                REPROCESS_FILES="false"
            fi

            log_wrapper_message "Message parsing completed"

            if [[ "${RUN_EXPORT}" == *"true"* ]]; then
                log_wrapper_message "Starting run of htme" "s3_location,s3://${S3_BUCKET}/${S3_FULL_FOLDER}"

                SECONDS=0

                /opt/htme/htme.sh "${S3_BUCKET}" "${S3_FULL_FOLDER}" "${TOPIC_NAME}" "${S3_MANIFEST_FOLDER}" \
                    "${S3_MANIFEST_BUCKET}" "${HBASE_MASTER_URL}" "${MAX_MEMORY_ALLOCATION}" \
                    "${CORRELATION_ID}" "${HTME_SCAN_WIDTH}" "${SQS_MESSAGE_ID}"  "${STATUS_TABLE_NAME}" \
                    "${START_DATE_TIME}" "${END_DATE_TIME}" "${SQS_OUTGOING_URL}" \
                    "${REPROCESS_FILES}" "${SHUTDOWN_SS}" "${EXPORT_DATE}" "${TRIGGER_SNAPSHOT_SENDER}" \
                    "${BLOCKED_TOPICS}" "${RECEIPT_HANDLE}" "${SQS_INCOMING_URL}" "${SNAPSHOT_TYPE}" \
                    "${SHUTDOWN_HTME}" "${SNS_TOPIC_ARN_MONITORING}" "${SNS_TOPIC_ARN_COMPLETION_INCREMENTAL}" \
                    "${SNS_TOPIC_ARN_COMPLETION_FULL}" "${TRIGGER_ADG}" "${PRODUCT_STATUS_TABLE_NAME}" \
                    "${SQS_MESSAGE_GROUP_ID}" "${SEND_TO_RIS}" "${DATA_EGRESS_SQS_URL}" \
                    "${SQS_MESSAGE_GROUP_ID}" "${SEND_TO_CRE}" "${DATA_EGRESS_SQS_URL}" &
                export PID=$!
                RUNNING=1

                delete_sqs_message "${RECEIPT_HANDLE}"

                while [[ ${RUNNING} -eq 1 ]]; do
                    log_wrapper_message "Looping while waiting for export process to complete" "status,${RUNNING}" \
                        "processing_time_duration,${SECONDS}"

                    set +e
                    RUNNING=$(ps --no-headers ${PID} | awk '{print $1}' | grep -c ${PID})
                    set -e

                    sleep 5
                done

                log_wrapper_message "Export run finished" "s3_location,s3://${S3_BUCKET}/${S3_FULL_FOLDER}" \
                    "processing_time_duration,${SECONDS}"
            else
                log_wrapper_message "Skipping export"

                delete_sqs_message "${RECEIPT_HANDLE}"
            fi

            reset_message_specific_vars "AWAITING_NEXT_MESSAGE"
        fi
    fi

    SQS_QUEUE_SECONDS_WITHOUT_MESSAGE=$((SQS_QUEUE_SECONDS_WITHOUT_MESSAGE + SLEEP_SECONDS))

    if [[ "${SHUTDOWN_HTME}" == "true" ]] && \
        [[ ${SQS_MESSAGES_PROCESSED_COUNT} -gt 0 ]] ; then

        # If last SQS message requested HTME to shut down AND we have done some work, then shutdown
        # Do it in here as it means we have a few minutes when there has been nothing on the SQS queue
        # Wait over 5 minutes after receiving last message to ensure flushed logs to cloudwatch

        if [[ ${SQS_QUEUE_SECONDS_WITHOUT_MESSAGE} -lt ${MINIMUM_SHUTDOWN_DELAY} ]]; then
            if ! ((SQS_QUEUE_CHECK_COUNT % 15 )) ; then
                # Only log this every minute so as not to spam the logs
                SECONDS_UNTIL_SHUTDOWN=$((MINIMUM_SHUTDOWN_DELAY - SQS_QUEUE_SECONDS_WITHOUT_MESSAGE))
                log_wrapper_message "Will detach from ASG and shutdown after 5 minutes" \
                    "seconds_until_shutdown,${SECONDS_UNTIL_SHUTDOWN}" "minimum_shutdown_delay,${MINIMUM_SHUTDOWN_DELAY}"
            fi
        else
            # Any log line here will never be seen
            detach_from_asg "${ASG_NAME}" "${INSTANCE_ID}"
            shutdown_after_successful_detachment
        fi
    else
        if ! ((SQS_QUEUE_CHECK_COUNT % 15 )) ; then
            # Only log this every minute so as not to spam the logs
            log_wrapper_message "Not shutting down yet due to SHUTDOWN_HTME and SQS_MESSAGES_PROCESSED_COUNT"
        fi
    fi

    sleep ${SLEEP_SECONDS}
done
