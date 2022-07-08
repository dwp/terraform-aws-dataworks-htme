#!/bin/bash

set -u

# rename ec2 instance to be unique
region_default=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | cut -d'"' -f4)
i_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)
UUID=$(dbus-uuidgen | cut -c 1-8)

export AWS_DEFAULT_REGION="$region_default"
export INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
export INSTANCE_ID="$i_id"
export HOSTNAME="${name}-$UUID"

hostnamectl set-hostname "$HOSTNAME"
aws ec2 create-tags --resources "$INSTANCE_ID" --tags Key=Name,Value="$HOSTNAME"

# Force LC update when any of these files are changed
echo "${s3_script_hash_htme_sh}" > /dev/null
echo "${s3_script_hash_htme_wrapper_sh}" > /dev/null
echo "${s3_script_hash_htme_logrotate}" > /dev/null
echo "${s3_script_hash_htme_cloudwatch_sh}" > /dev/null
echo "${s3_script_hash_common_logging_sh}" > /dev/null
echo "${s3_script_hash_logging_sh}" > /dev/null
echo "${s3_script_hash_wrapper_checker_sh}" > /dev/null

export http_proxy="http://${internet_proxy}:3128"
export HTTP_PROXY="$http_proxy"
export https_proxy="$http_proxy"
export HTTPS_PROXY="$https_proxy"
export no_proxy="${non_proxied_endpoints}"
export NO_PROXY="$no_proxy"

echo "Configure AWS Inspector"
cat > /etc/init.d/awsagent.env << AWSAGENTPROXYCONFIG
export https_proxy=$https_proxy
export http_proxy=$http_proxy
export no_proxy=$no_proxy
AWSAGENTPROXYCONFIG

/etc/init.d/awsagent stop
sleep 5
/etc/init.d/awsagent start

echo "Downloading startup scripts"
S3_URI_SHELL="s3://${s3_scripts_bucket}/${s3_script_key_htme_sh}"
S3_URI_WRAPPER="s3://${s3_scripts_bucket}/${s3_script_key_htme_wrapper_sh}"
S3_URI_LOGROTATE="s3://${s3_scripts_bucket}/${s3_script_key_htme_logrotate}"
S3_CLOUDWATCH_SHELL="s3://${s3_scripts_bucket}/${s3_script_htme_cloudwatch_sh}"
S3_COMMON_LOGGING_SHELL="s3://${s3_scripts_bucket}/${s3_script_common_logging_sh}"
S3_LOGGING_SHELL="s3://${s3_scripts_bucket}/${s3_script_logging_sh}"
S3_WRAPPER_CHECKER="s3://${s3_scripts_bucket}/${s3_script_wrapper_checker_sh}"

echo "Creating shared directory"
mkdir -p /opt/shared/

echo "Installing scripts"
$(which aws) s3 cp "$S3_URI_SHELL"              /opt/htme/htme.sh
$(which aws) s3 cp "$S3_URI_WRAPPER"            /opt/htme/htme_wrapper.sh
$(which aws) s3 cp "$S3_URI_LOGROTATE"          /etc/logrotate.d/htme
$(which aws) s3 cp "$S3_CLOUDWATCH_SHELL"       /opt/htme/htme_cloudwatch.sh
$(which aws) s3 cp "$S3_COMMON_LOGGING_SHELL"   /opt/shared/common_logging.sh
$(which aws) s3 cp "$S3_LOGGING_SHELL"          /opt/htme/logging.sh
$(which aws) s3 cp "$S3_WRAPPER_CHECKER"        /opt/htme/wrapper_checker.sh

echo "Allow shutting down"
echo "htme     ALL = NOPASSWD: /sbin/shutdown -h now" >> /etc/sudoers

echo "Creating directories"
mkdir -p /opt/htme/config/
mkdir -p /var/log/htme
mkdir -p /opt/htme/manifest/

echo "Creating user htme"
useradd htme -m

echo "Setup cloudwatch logs"
chmod u+x /opt/htme/htme_cloudwatch.sh
/opt/htme/htme_cloudwatch.sh \
    "${cwa_metrics_collection_interval}" "${cwa_namespace}" "${cwa_cpu_metrics_collection_interval}" \
    "${cwa_disk_measurement_metrics_collection_interval}" "${cwa_disk_io_metrics_collection_interval}" \
    "${cwa_mem_metrics_collection_interval}" "${cwa_netstat_metrics_collection_interval}" "${cwa_log_group_name_htme}" \
    "${cwa_log_group_name_acm}" "${cwa_log_group_name_application}" "${cwa_log_group_name_boostrapping}"\
    "${cwa_log_group_name_system}" "$AWS_DEFAULT_REGION" 

echo "Download & install latest hbase-to-mongo-export service artifact"
VERSION="${htme_version}"
URL="s3://${s3_artefact_bucket_id}/hbase-to-mongo-export/hbase-to-mongo-export-$VERSION.jar"
$(which aws) s3 cp $URL /opt/htme/htme.jar
echo "JAR_VERSION: $VERSION"
echo "JAR_DOWNLOAD_URL: $URL"
echo "$VERSION" > /opt/htme/version
echo "${htme_log_level}" > /opt/htme/log_level
echo "${environment_name}" > /opt/htme/environment

# Retrieve certificates
TRUSTSTORE_PASSWORD=$(uuidgen -r)
KEYSTORE_PASSWORD=$(uuidgen -r)
PRIVATE_KEY_PASSWORD=$(uuidgen -r)
ACM_KEY_PASSWORD=$(uuidgen -r)

acm-cert-retriever \
--acm-cert-arn "${acm_cert_arn}" \
--acm-key-passphrase "$ACM_KEY_PASSWORD" \
--keystore-path "/opt/htme/keystore.jks" \
--keystore-password "$KEYSTORE_PASSWORD" \
--private-key-alias "${private_key_alias}" \
--private-key-password "$PRIVATE_KEY_PASSWORD" \
--truststore-path "/opt/htme/truststore.jks" \
--truststore-password "$TRUSTSTORE_PASSWORD" \
--truststore-aliases "${truststore_aliases}" \
--truststore-certs "${truststore_certs}" >> /var/log/acm-cert-retriever.log 2>&1

cat > /opt/htme/config/application.properties <<HTME_CFG
spring.main.banner-mode=off
spring.profiles.active=${htme_spring_profiles}
logging.level.root=${htme_log_level}
data.key.service.url=${dks_endpoint}
encrypt.output=true
compress.output=true
identity.keystore=/opt/htme/keystore.jks
identity.store.password=$KEYSTORE_PASSWORD
identity.store.alias=${private_key_alias}
identity.key.password=$PRIVATE_KEY_PASSWORD
trust.keystore=/opt/htme/truststore.jks
trust.store.password=$TRUSTSTORE_PASSWORD
output.batch.size.max.bytes=${output_batch_size_max_bytes}
manifest.output.directory=/opt/htme/manifest/
s3.socket.timeout=${htme_s3_socket_timeout_milliseconds}
scan.max.result.size=${htme_scan_max_result_size}
scan.cache.blocks=${htme_use_block_cache}
use.timeline.consistency=${htme_use_timeline_consistency}
snapshot.sender.sqs.message.group.id=${sqs_message_group_id}
manifest.retry.maxAttempts=${htme_manifest_retry_max_attempts}
manifest.retry.delay=${htme_manifest_retry_delay_ms}
manifest.retry.multiplier=${htme_manifest_retry_multiplier}
pushgateway.host=${pushgateway_hostname}
hbase.scanner.timeout.ms=${hbase_scanner_timeout_ms}
hbase.rpc.timeout.ms=${hbase_rpc_timeout_ms}
hbase.rpc.read.timeout.ms=${hbase_rpc_read_timeout_ms}
instance.name=$HOSTNAME
pdm.common.model.site.prefix=${pdm_common_model_site_prefix}
HTME_CFG

echo "Changing permissions and moving files"
chmod u+x /opt/shared/common_logging.sh
chmod u+x /opt/htme/logging.sh
chmod u+x /opt/htme/htme.sh
chmod u+x /opt/htme/htme_wrapper.sh
chmod u+x /opt/htme/wrapper_checker.sh
chown htme:htme -R  /opt/shared
chown htme:htme -R  /opt/htme
chown htme:htme -R  /var/log/htme

echo "Shutdown if key store hasn't been created successfully"
if [ ! -e /opt/htme/keystore.jks ] || [ ! -e /opt/htme/truststore.jks ]; then
    echo "No key store and/or trust store exists at /opt/htme/ so shutting down"
    sleep 5 # Log flush
    sudo /sbin/shutdown -h now
else
    echo "Start exporter"
    su -p htme -c "nohup /opt/htme/htme_wrapper.sh ${s3_bucket} ${sqs_url} $INSTANCE_ID \
        ${sqs_incoming_url} $HTTP_PROXY $NO_PROXY ${s3_manifest_folder} ${s3_manifest_bucket} \
        ${asg_name} ${hbase_master_url} ${htme_max_memory_allocation} \
        ${htme_scan_width} ${status_table_name} ${blocked_topics} ${sns_topic_arn_monitoring} \
        ${sns_topic_arn_completion_incremental} ${sns_topic_arn_completion_full} \
        ${product_status_table_name} ${sqs_message_group_id} ${data_egress_sqs_url} > /var/log/htme/nohup.log" &

    sleep 30

    echo WRAPPER_PID=$(ps aux | grep '[ ]/bin/bash /opt/htme/htme_wrapper.sh' | awk '{print $2}') >> /etc/environment

    # Adds wrapper_checker to crontab and run every minute
    crontab -l | { cat; echo "* * * * * /opt/htme/wrapper_checker.sh >> /var/log/htme/nohup.log 2>&1"; } | crontab -
fi
