variable "common_tags" {
    description = "A set of common tags to identify the HTME application."
    type = map(string)
}

variable "domain_name" {
    description = "The domain name of the infrastructure HTME will be deployed to."
    type = string
}

variable "image_id" {
    description = "The ID AMI to use to launch the instance."
    type = string
}

variable "instance_type" {
    description = "The instance type to use for HTME."
    type = string
}

variable "fallback_instance_type" {
    description = "The instance type to use for the fallback HTME."
    type = string
}

variable "ebs_size" {
    description = "The size of the root volume for the HTME instances."
    type = string
}

variable "ebs_type" {
    description = "The type of EBS root volume for the HTME instances."
    type = string
}

variable "asg_name" {
    description = "The name of the Auto Scaling Group (ASG) used to deploy HTME."
    type = string
    default = "htme_asg"
}

variable "asg_min" {
    description = "The minimum number of instances in a given HTME ASG."
    type = number
    default = 0
}

variable "asg_desired" {
    description = "The desired number of instances in a given HTME ASG. Alambda is used to scale this out hence a default of 0."
    type = number
    default = 0
}

variable "asg_max" {
    description = "The maximum number of instances in a given HTME ASG."
    type = number
    default = 3
}

variable "health_check_grace_period" {
    description = "Time (in seconds) after instance comes into service before checking health."
    type = number
    default = 600
}

variable "health_check_type" {
    description = "EC2 or ELB. Controls how health checking is done."
    type = string
    default = "EC2"
}

variable "suspended_processes" {
    description = "A list of processes to suspend for the Auto Scaling Group. The allowed values are Launch, Terminate, HealthCheck, ReplaceUnhealthy, AZRebalance, AlarmNotification, ScheduledActions, AddToLoadBalancer. We default to AZRebalance as we don't want to suspend HTME instances mid running due to uneven instances across AZs."
    type = list(string)
    default = ["AZRebalance"]
}

variable "instance_name" {
    description = "The name of the HTME instances held within the ASG."
    type = string
}

variable "htme_version" {
    description = "Hbase to Mongo export JAR release version."
    type        = string
}

variable "spring_profiles" {
    description = "Specifies the spring profiles to pass to the HTME application."
    type = string
    default = "aesCipherService,secureHttpClient,httpDataKeyService,realHbaseDataSource,awsConfiguration,outputToS3,batchRun,weakRng,gzCompressor"
}

variable "asg_autoshutdown" {
    description = "A tag specifying whether we should automatically shut HTME down. We must never do this with a live HTME application."
    type = string
    default = "False"
}

variable "asg_ssm_enabled" {
    type = string
    default = "False"
}

variable "inspector" {
    description = "Enabled inspector assessment."
    type = string
    default = "disabled"
}

variable "scheduler_sqs_queue_name" {
    description = "The name of the scheduler SQS Queue."
    type = string
}

variable "corporate_storage_export_sqs_queue_name" {
    description = "The name of the corporate storage export SQS Queue."
    type = string
}

variable "environment" {
    description = "Name of the environment to deploy to."
    type = string
}

variable "host_truststore_aliases" {
    description = "The alias of the CA certificates HTME should trust."
    type = string
}

variable "host_truststore_certs" {
    description = "The location of the CA certificates."
    type = string
}

variable "internet_proxy_dns_name" {
    description = "The DNS Name of the internet proxy VPC Endpoint."
    type = string
}

variable "non_proxied_endpoints" {
    description = "A string of service endpoints delimited by a comma (',')."
    type = string
}

variable "s3_artefact_bucket_id" {
    description = "The ID of the artifact S3 bucket."
    type = string
}

variable "htme_log_level" {
    description = "The log level of HTME."
    type = string
    default = "INFO"
}

variable "dks_endpoint" {
    description = "The endpoint of the Data Key Service."
    type = string
}

variable "output_batch_size_max_bytes" {
    description = "Max size in bytes of output chunks."
    default     = "1073741824"
}

variable "directory_output" {
    description = "Output directoy when in local output mode."
    default     = "/tmp/hbase-export"
}

variable "s3_compaction_bucket_id" {
    description = "The ID of the compaction S3 bucket."
    type = string
}

variable "s3_manifest_prefix" {
    description = "The prefix of the S3 manifest bucket."
    type = string
}

variable "s3_manifest_bucket_id" {
    description = "The ID of the manifest S3 bucket."
    type = string
}

variable "s3_config_bucket_id" {
    description = "The ID of the config S3 bucket."
    type = string
}

variable "hbase_master_url" {
    description = "The URL of the HBASE Master HTME should read from."
    type = string
}

variable "max_memory_allocation" {
    description = "The Max memory allocation for heap."
    type = string
    default = "NOT_SET"
}

variable "scan_width" {
    description = "How much of the keyspace each scanner should scan."
    type = string
    default = "2"
}

variable "cw_agent_namespace" {
    description = "The CloudWatch namespace to send logs and metrics to."
    type = string
    default = "/app/htme"
}

variable "cw_agent_metrics_collection_interval" {
    description = "The interval at which the Cloud Watch agent should collect metrics."
    type = number
    default = 60
}

variable "cw_agent_cpu_metrics_collection_interval" {
    description = "The interval at which the Cloud Watch agent should collect CPU metrics."
    type = number
    default = 60
}

variable "cw_agent_disk_measurement_metrics_collection_interval" {
    description = "The interval at which the Cloud Watch agent should collect disk measurement metrics."
    type = number
    default = 60
}

variable "cw_agent_disk_io_metrics_collection_interval" {
    description = "The interval at which the Cloud Watch agent should collect disk io metrics."
    type = number
    default = 60
}

variable "cw_agent_mem_metrics_collection_interval" {
    description = "The interval at which the Cloud Watch agent should collect memory metrics."
    type = number
    default = 60
}

variable "cw_agent_netstat_metrics_collection_interval" {
    description = "The interval at which the Cloud Watch agent should collect netstat metrics."
    type = number
    default = 60
}

variable "common_logging_sh_content_hash" {
    description = "The content as a hash of the common logging script to deploy to HTME."
    type = string
}

variable "uc_export_to_crown_status_table_name" {
    description = "The name of the uc_export_to_crown_status table."
    type = string
}

variable "data_pipeline_metadata_name" {
    description = "The name of the data_pipeline_metadata table."
    type = string
}

variable "message_delay_seconds" {
    type = number
    default = 1
}

variable "manifest_retry_max_attempts" {
    description = "The number of retries to attempt to write to the manifest bucket before giving up."
    type = number
    default = 2
}

variable "manifest_retry_delay_ms" {
    description = "The time to wait in ms before retrying a write to the manifest bucket."
    type = number
    default = 1000
}

variable "manifest_retry_multiplier" {
    description = "The backoff multiplier (the retry delay is this multiple of the previous delay) for retrying writes to the manifest bucket."
    type = number
    default = 2
}

variable "blocked_topics" {
    description = "A CSV of blocked topics that aren't allowed to be exported to Crown"
    type        = string
    default     = "db.no.topicIs.blockedATM"
}

variable "sns_topic_arn_monitoring" {
    description = "The ARN of the monitoring topic to send alerts and notifcations to."
    type = 
}

variable "sns_topic_arn_completion_incremental" {
    description = "The ARN of the SNS topic to send the adg triggering message for incremental exports."
    type = string
}

variable "sns_topic_arn_completion_full" {
    description = "The ARN of the SNS topic to send the adg triggering message for full exports."
    type = string
}

variable "htme_pushgateway_hostname" {
    description = "The hostname of the HTME Prometheus Pushgateway."
    type = string
}

variable "sqs_messages_group_id_retries" {
    description = "The SQS message group ID that failed topic retry messages should be sent to."
    type = string
    default = "retried_collection_exports"
}

variable "hbase_client_scanner_timeout_ms" {
    description = "The timeout of the server side (per client can overwrite) for a scanner to complete its work."
    type = string
    default = "600000"
}

variable "hbase_rpc_timeout_ms" {
    description = "The timeout of the server side (per client can overwrite) for a single RPC call."
    type = string
    default = "600000"
}

variable "hbase_rpc_read_timeout_ms" {
    description = "The timeout of the server side (per client can overwrite) for a single RPC read only call."
    type = string
    type = "600000"
}

variable "data_egress_sqs_url" {
    description = "The queue to which notifications of exported RIS files are sent."
    type = string
}

variable "pdm_common_model_site_prefix" {
    type = string
    default = "common-model-inputs/data/site/pipeline_success.flag"
}

variable "s3_socket_timeout_milliseconds" {
    description = "How long HTME should wait for an s3 connection before giving up"
    type = string
    default = "180000"
}

variable "scan_max_result_size" {
    description = "The maximum number of rows to place in the client side cache. Default is unlimited."
    type = string
    default = "-1"
}

variable "use_block_cache" {
    description = "Whether HTME should enable scan cache blocks on the hbase scanner"
    type = string
    default = "false"
}

variable "use_timeline_consistency" {
    description = "Whether HTME should scan the region replicas or only the master. Default of false means strong consistency."
    type = string
    default = "false"
}

variable "s3_script_common_logging_sh_id" {
    description = "The ID of the S3 bucket holding the common logging script."
    type = string
}

variable "s3_script_logging_sh_id" {
    description = "The ID of the S3 bucket holding the logging script."
    type = string
}

variable "logging_sh_content_hash" {
    description = "The content as a hash of the logging script to deploy to HTME."
    type = string
}

variable "root_ca_arn" {
    description = "The ARN of the root CA certificate."
    type = 
}

variable "" {
    description = ""
    type = 
}

variable "" {
    description = ""
    type = 
}

variable "" {
    description = ""
    type = 
}

