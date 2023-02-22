provider "aws" {
  region = "eu-west-1"

  default_tags {

    tags = {
      Application      = "DataWorks"                              # As per our definition on ServiceNow
      Function         = "Data and Analytics"                     # As per our definition on ServiceNow
      Environment      = local.hcs_environment[local.environment] # Set up locals as per Tagging doc requirements https://engineering.dwp.gov.uk/policies/hcs-cloud-hosting-policies/resource-identification-tagging/
      Business-Project = "PRJ0022507"                             # This seems to replace costcode as per the doc https://engineering.dwp.gov.uk/policies/hcs-cloud-hosting-policies/resource-identification-tagging/
      DWX-Aplication   = "terratest"
    }
  }

  /* assume_role {
    role_arn = "arn:aws:iam::${var.test_account}:role/${var.assume_role}"

  } */

}

/* variable "assume_role" {
  type        = string
  default     = "ci"
  description = "Role to assume"
}

variable "test_account" {
  type        = string
  description = "Test AWS Account number"

} */

module "terratest_htme" {
  source = "../"

  # Metadata
  account_number = local.account[local.environment]
  environment    = local.environment
  region         = "eu-west-1"
  common_tags    = local.common_tags

  # Launch Template
  image_id               = var.al2_hardened_ami_id #Need to identify
  instance_type          = "t2.small"
  fallback_instance_type = "t3.small"
  ebs_size               = 167
  ebs_type               = "gp3"

  # Auto-Scaling Group
  asg_name                  = "terratest_htme_asg"
  asg_min                   = 0
  asg_desired               = 0
  asg_max                   = 3
  health_check_grace_period = 600
  health_check_type         = "EC2"
  vpc_id                    = module.terratest_htme_vpc.vpc.id
  subnet_ids                = aws_subnet.htme.*.id

  # AutoSG Tags
  asg_autoshutdown = "True"
  asg_ssm_enabled  = "True"
  inspector        = "disabled"

  # IAM
  iam_role_max_session_timeout_seconds = 43200

  # Certificate
  root_ca_arn = data.terraform_remote_state.certificate_authority.outputs.root_ca.arn
  domain_name = "terratest_htme.${local.dw_domain}"

  # Scripts
  htme_default_topics_ris_base64 = data.local_file.htme_default_topics_ris_csv.content_base64
  s3_config_bucket_id            = data.terraform_remote_state.common.outputs.config_bucket.id
  s3_config_bucket_arn           = data.terraform_remote_state.common.outputs.config_bucket.arn
  config_bucket_cmk_arn          = data.terraform_remote_state.common.outputs.config_bucket_cmk.arn
  s3_script_logging_sh_id        = aws_s3_bucket_object.logging_script.id
  logging_sh_content_hash        = md5(data.local_file.logging_script.content)
  s3_script_common_logging_sh_id = data.terraform_remote_state.common.outputs.application_logging_common_file.s3_id
  common_logging_sh_content_hash = data.terraform_remote_state.common.outputs.application_logging_common_file.hash

  # SQS Variables
  scheduler_sqs_queue_url                = data.aws_sqs_queue.scheduler_sqs.url
  corporate_storage_export_sqs_queue_url = data.aws_sqs_queue.corporate_storage_export_sqs.url
  sqs_messages_group_id_retries          = "retried_collection_exports"
  data_egress_sqs_url                    = data.terraform_remote_state.common.outputs.data_egress_sqs.id
  export_state_fifo_sqs_arn              = data.terraform_remote_state.common.outputs.export_state_fifo_sqs.arn
  corporate_storage_export_sqs_arn       = data.terraform_remote_state.common.outputs.corporate_storage_export_sqs.arn
  data_egress_sqs_arn                    = data.terraform_remote_state.common.outputs.data_egress_sqs.arn
  export_state_fifo_sqs_key_arn          = data.terraform_remote_state.common.outputs.export_state_fifo_sqs.key_arn
  corporate_storage_export_sqs_key_arn   = data.terraform_remote_state.common.outputs.corporate_storage_export_sqs.key_arn

  # S3 Buckets
  s3_artefact_bucket_id     = data.terraform_remote_state.management_artefact.outputs.artefact_bucket.id
  s3_artefact_bucket_arn    = data.terraform_remote_state.management_artefact.outputs.artefact_bucket.arn
  artefact_bucket_cmk_arn   = data.terraform_remote_state.management_artefact.outputs.artefact_bucket.cmk_arn
  s3_compaction_bucket_id   = aws_s3_bucket.compaction.id
  s3_compaction_bucket_arn  = aws_s3_bucket.compaction.arn
  compaction_bucket_cmk_arn = aws_kms_key.compaction_bucket_cmk.arn
  s3_manifest_bucket_id     = aws_s3_bucket.manifest_bucket.id
  s3_manifest_bucket_arn    = aws_s3_bucket.manifest_bucket.arn
  s3_manifest_prefix        = "${data.terraform_remote_state.ingestion.outputs.manifest_s3_prefixes.base}/export"
  manifest_bucket_cmk_arn   = aws_kms_key.manifest_bucket_cmk.arn
  public_cert_bucket_arn    = data.terraform_remote_state.certificate_authority.outputs.public_cert_bucket.arn
  input_bucket_cmk_arn      = data.terraform_remote_state.ingestion.outputs.input_bucket_cmk.arn

  # Logging
  cw_agent_namespace                              = "/terratest/app/htme"
  cw_agent_controller_namespace                   = "/terratest/app/lambda/uc_export_to_crown_controller"
  cw_agent_log_group_name_htme                    = aws_cloudwatch_log_group.htme.name
  cw_agent_log_group_name_acm                     = aws_cloudwatch_log_group.acm_cert_retriever.name
  cw_agent_log_group_name_application             = aws_cloudwatch_log_group.application.name
  cw_agent_log_group_name_boostrapping            = aws_cloudwatch_log_group.bootstrapping.name
  cw_agent_log_group_name_system                  = aws_cloudwatch_log_group.system.name
  cw_uc_export_to_crown_controller_log_group_name = aws_cloudwatch_log_group.uc_export_to_crown_controller.name

  # Metrics
  cw_agent_metrics_collection_interval                  = 60
  cw_agent_cpu_metrics_collection_interval              = 60
  cw_agent_disk_measurement_metrics_collection_interval = 60
  cw_agent_disk_io_metrics_collection_interval          = 60
  cw_agent_mem_metrics_collection_interval              = 60
  cw_agent_netstat_metrics_collection_interval          = 60
  sns_topic_arn_monitoring_arn                          = data.terraform_remote_state.security_tools.outputs.sns_topic_london_monitoring.arn
  sns_topic_arn_completion_incremental                  = aws_sns_topic.export_status_sns_incrementals.arn
  sns_topic_arn_completion_full                         = aws_sns_topic.export_status_sns_fulls.arn
  export_status_sns_fulls_arn                           = aws_sns_topic.export_status_sns_fulls.arn
  export_status_sns_incrementals_arn                    = aws_sns_topic.export_status_sns_incrementals.arn
  htme_pushgateway_hostname                             = "${aws_service_discovery_service.htme_services.name}.${aws_service_discovery_private_dns_namespace.htme_services.name}"

  # Alerting
  htme_alert_on_failed_manifest_writes = false
  htme_alert_on_failed_to_start        = false
  htme_alert_on_collection_duration    = false
  htme_alert_on_read_failures          = false
  htme_alert_on_failed_snapshots       = false
  htme_alert_on_dks_errors             = false
  htme_alert_on_dks_retries            = false
  htme_alert_on_rejected_records       = false
  htme_alert_on_failed_collections     = false
  htme_alert_on_memory_usage           = false

  # User Data
  instance_name               = "terratest-htme-host-${local.environment}"
  htme_version                = var.htme_version
  spring_profiles             = "aesCipherService,secureHttpClient,httpDataKeyService,realHbaseDataSource,awsConfiguration,outputToS3,batchRun,weakRng,gzCompressor"
  host_truststore_aliases     = "dataworks_root_ca,dataworks_mgt_root_ca"
  host_truststore_certs       = "s3://${data.terraform_remote_state.certificate_authority.outputs.public_cert_bucket.id}/ca_certificates/dataworks/dataworks_root_ca.pem,s3://${data.terraform_remote_state.mgmt_ca.outputs.public_cert_bucket.id}/ca_certificates/dataworks/dataworks_root_ca.pem"
  internet_proxy_dns_name     = aws_vpc_endpoint.internet_proxy.dns_entry[0].dns_name
  non_proxied_endpoints       = join(",", module.terratest_htme_vpc.no_proxy_list)
  htme_log_level              = "DEBUG"
  dks_endpoint                = data.terraform_remote_state.crypto.outputs.dks_endpoint[local.environment]
  output_batch_size_max_bytes = "1073741824"
  directory_output            = "/tmp/hbase-export"
  hbase_master_url            = data.terraform_remote_state.aws_internal_compute.outputs.aws_emr_cluster.fqdn
  max_memory_allocation       = "NOT_SET"
  scan_width                  = "2"


  uc_export_to_crown_status_table_name = aws_dynamodb_table.terratest_uc_export_to_crown_status_table.name
  uc_export_to_crown_status_table_arn  = aws_dynamodb_table.terratest_uc_export_to_crown_status_table.arn
  data_pipeline_metadata_name          = aws_dynamodb_table.terratest_data_pipeline_metadata.name
  data_pipeline_metadata_arn           = aws_dynamodb_table.terratest_data_pipeline_metadata.arn
  message_delay_seconds                = 1
  manifest_retry_max_attempts          = 2
  manifest_retry_delay_ms              = 1000
  manifest_retry_multiplier            = 2
  hbase_client_scanner_timeout_ms      = 600000
  hbase_rpc_timeout_ms                 = 600000
  hbase_rpc_read_timeout_ms            = 600000
  pdm_common_model_site_prefix         = "common-model-inputs/data/site/pipeline_success.flag"
  scan_max_result_size                 = "-1"
  use_block_cache                      = false
  use_timeline_consistency             = false
  default_ebs_cmk_arn                  = data.terraform_remote_state.security_tools.outputs.ebs_cmk.arn
  s3_socket_timeout_milliseconds       = "180000"
}
