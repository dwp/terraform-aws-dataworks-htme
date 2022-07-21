# terraform-aws-dataworks-htme
A terraform module to deploy the HBASE-To-Mongo-Export Batch Application


<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.22.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.2.3 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.htme](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_autoscaling_group.htme](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_cloudwatch_dashboard.htme](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_dashboard) | resource |
| [aws_cloudwatch_log_metric_filter.htme_collection_duration_ms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_log_metric_filter.htme_collections_failed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_log_metric_filter.htme_collections_started](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_log_metric_filter.htme_collections_successfully_completed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_log_metric_filter.htme_dks_errors](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_log_metric_filter.htme_dks_retries](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_log_metric_filter.htme_failed_manifest_writes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_log_metric_filter.htme_failed_snapshots](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_log_metric_filter.htme_read_failures](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_log_metric_filter.htme_records_processed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_log_metric_filter.htme_rejected_hbase_records](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_log_metric_filter.htme_requested_topics_to_export](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_log_metric_filter.htme_requested_topics_to_send](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_log_metric_filter.htme_successful_empty_collections](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_log_metric_filter.htme_successful_non_empty_collections](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_metric_alarm.collection_duration_ms_exceeded_average](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.collections_failed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.htme_dks_errors](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.htme_dks_retries](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.htme_failed_manifest_write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.htme_failed_snapshots](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.htme_failed_to_start_in_24h](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.htme_memory_usage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.htme_read_failures](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.htme_rejected_hbase_records](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_iam_instance_profile.htme](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.htme_main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.htme](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.htme_cwasp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.htme_emr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.htme_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_template.htme](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_launch_template.htme_fallback](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_s3_object.htme_cloudwatch_script](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.htme_default_topics_drift_testing_incrementals_csv](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.htme_default_topics_full_csv](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.htme_default_topics_incrementals_csv](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.htme_default_topics_ris_csv](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.htme_logrotate_script](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.htme_shell_script](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.htme_wrapper_script](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.wrapper_checker_script](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_secretsmanager_secret.htme_collections_ris](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.htme_collections_ris](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.htme](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_iam_policy_document.htme_main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.htme_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_sqs_queue.corporate_storage_export_sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/sqs_queue) | data source |
| [aws_sqs_queue.scheduler_sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/sqs_queue) | data source |
| [local_file.htme_cloudwatch_script](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
| [local_file.htme_default_topics_drift_testing_incrementals_csv](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
| [local_file.htme_default_topics_full_csv](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
| [local_file.htme_default_topics_incrementals_csv](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
| [local_file.htme_default_topics_ris_csv](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
| [local_file.htme_logrotate_script](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
| [local_file.htme_shell_script](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
| [local_file.htme_wrapper_script](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
| [local_file.wrapper_checker_script](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
| [template_file.htme](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.htme_fallback](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_number"></a> [account\_number](#input\_account\_number) | The AWS Account Number to deploy to. | `string` | n/a | yes |
| <a name="input_artefact_bucket_cmk_arn"></a> [artefact\_bucket\_cmk\_arn](#input\_artefact\_bucket\_cmk\_arn) | The ARN of the KMS Key belonging to the Artefact S3 Bucket. | `string` | n/a | yes |
| <a name="input_asg_autoshutdown"></a> [asg\_autoshutdown](#input\_asg\_autoshutdown) | A tag specifying whether we should automatically shut HTME down. We must never do this with a live HTME application. | `string` | `"False"` | no |
| <a name="input_asg_desired"></a> [asg\_desired](#input\_asg\_desired) | The desired number of instances in a given HTME ASG. Alambda is used to scale this out hence a default of 0. | `number` | `0` | no |
| <a name="input_asg_max"></a> [asg\_max](#input\_asg\_max) | The maximum number of instances in a given HTME ASG. | `number` | `3` | no |
| <a name="input_asg_min"></a> [asg\_min](#input\_asg\_min) | The minimum number of instances in a given HTME ASG. | `number` | `0` | no |
| <a name="input_asg_name"></a> [asg\_name](#input\_asg\_name) | The name of the Auto Scaling Group (ASG) used to deploy HTME. | `string` | `"htme_asg"` | no |
| <a name="input_asg_ssm_enabled"></a> [asg\_ssm\_enabled](#input\_asg\_ssm\_enabled) | n/a | `string` | `"False"` | no |
| <a name="input_blocked_topics"></a> [blocked\_topics](#input\_blocked\_topics) | A CSV of blocked topics that aren't allowed to be exported to Crown | `string` | `"db.no.topicIs.blockedATM"` | no |
| <a name="input_common_logging_sh_content_hash"></a> [common\_logging\_sh\_content\_hash](#input\_common\_logging\_sh\_content\_hash) | The content as a hash of the common logging script to deploy to HTME. | `string` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | A set of common tags to identify the HTME application. | `map(string)` | n/a | yes |
| <a name="input_compaction_bucket_cmk_arn"></a> [compaction\_bucket\_cmk\_arn](#input\_compaction\_bucket\_cmk\_arn) | The KMS Key ARN belonging to the compaction S3 bucket. | `string` | n/a | yes |
| <a name="input_config_bucket_cmk_arn"></a> [config\_bucket\_cmk\_arn](#input\_config\_bucket\_cmk\_arn) | The ARN of the KMS Key belonging to the Config S3 Bucket. | `string` | n/a | yes |
| <a name="input_corporate_storage_export_sqs_arn"></a> [corporate\_storage\_export\_sqs\_arn](#input\_corporate\_storage\_export\_sqs\_arn) | The ARN of the Corporate Storage Export SQS Queue. | `string` | n/a | yes |
| <a name="input_corporate_storage_export_sqs_key_arn"></a> [corporate\_storage\_export\_sqs\_key\_arn](#input\_corporate\_storage\_export\_sqs\_key\_arn) | The ARN of the KMS Key belonging to the Corporate Storage Export SQS Queue. | `string` | n/a | yes |
| <a name="input_corporate_storage_export_sqs_queue_name"></a> [corporate\_storage\_export\_sqs\_queue\_name](#input\_corporate\_storage\_export\_sqs\_queue\_name) | The name of the corporate storage export SQS Queue. | `string` | n/a | yes |
| <a name="input_cw_agent_controller_namespace"></a> [cw\_agent\_controller\_namespace](#input\_cw\_agent\_controller\_namespace) | The CloudWatch namespace belonging to the uc\_export\_to\_crown\_controller Lambda. | `string` | n/a | yes |
| <a name="input_cw_agent_cpu_metrics_collection_interval"></a> [cw\_agent\_cpu\_metrics\_collection\_interval](#input\_cw\_agent\_cpu\_metrics\_collection\_interval) | The interval at which the Cloud Watch agent should collect CPU metrics. | `number` | `60` | no |
| <a name="input_cw_agent_disk_io_metrics_collection_interval"></a> [cw\_agent\_disk\_io\_metrics\_collection\_interval](#input\_cw\_agent\_disk\_io\_metrics\_collection\_interval) | The interval at which the Cloud Watch agent should collect disk io metrics. | `number` | `60` | no |
| <a name="input_cw_agent_disk_measurement_metrics_collection_interval"></a> [cw\_agent\_disk\_measurement\_metrics\_collection\_interval](#input\_cw\_agent\_disk\_measurement\_metrics\_collection\_interval) | The interval at which the Cloud Watch agent should collect disk measurement metrics. | `number` | `60` | no |
| <a name="input_cw_agent_log_group_name_acm"></a> [cw\_agent\_log\_group\_name\_acm](#input\_cw\_agent\_log\_group\_name\_acm) | The CloudWatch Log Group Name to give to AWS Certificate Manager Logs. | `string` | `"/app/htme/acm"` | no |
| <a name="input_cw_agent_log_group_name_application"></a> [cw\_agent\_log\_group\_name\_application](#input\_cw\_agent\_log\_group\_name\_application) | The CloudWatch Log Group Name to give to Application Logs. | `string` | `"/app/htme/application"` | no |
| <a name="input_cw_agent_log_group_name_boostrapping"></a> [cw\_agent\_log\_group\_name\_boostrapping](#input\_cw\_agent\_log\_group\_name\_boostrapping) | The CloudWatch Log Group Name to give to Bootstrapping Logs. | `string` | `"/app/htme/boostrapping"` | no |
| <a name="input_cw_agent_log_group_name_htme"></a> [cw\_agent\_log\_group\_name\_htme](#input\_cw\_agent\_log\_group\_name\_htme) | The CloudWatch Log Group Name to give to HTME Logs. | `string` | `"/app/htme"` | no |
| <a name="input_cw_agent_log_group_name_system"></a> [cw\_agent\_log\_group\_name\_system](#input\_cw\_agent\_log\_group\_name\_system) | The CloudWatch Log Group Name to give to System Logs. | `string` | `"/app/htme/system"` | no |
| <a name="input_cw_agent_mem_metrics_collection_interval"></a> [cw\_agent\_mem\_metrics\_collection\_interval](#input\_cw\_agent\_mem\_metrics\_collection\_interval) | The interval at which the Cloud Watch agent should collect memory metrics. | `number` | `60` | no |
| <a name="input_cw_agent_metrics_collection_interval"></a> [cw\_agent\_metrics\_collection\_interval](#input\_cw\_agent\_metrics\_collection\_interval) | The interval at which the Cloud Watch agent should collect metrics. | `number` | `60` | no |
| <a name="input_cw_agent_namespace"></a> [cw\_agent\_namespace](#input\_cw\_agent\_namespace) | The CloudWatch namespace to send logs and metrics to. | `string` | `"/app/htme"` | no |
| <a name="input_cw_agent_netstat_metrics_collection_interval"></a> [cw\_agent\_netstat\_metrics\_collection\_interval](#input\_cw\_agent\_netstat\_metrics\_collection\_interval) | The interval at which the Cloud Watch agent should collect netstat metrics. | `number` | `60` | no |
| <a name="input_cw_uc_export_to_crown_controller_log_group_name"></a> [cw\_uc\_export\_to\_crown\_controller\_log\_group\_name](#input\_cw\_uc\_export\_to\_crown\_controller\_log\_group\_name) | The CloudWatch Log Group Name belonging to the uc\_export\_to\_crown\_controller Lambda. | `string` | n/a | yes |
| <a name="input_data_egress_sqs_arn"></a> [data\_egress\_sqs\_arn](#input\_data\_egress\_sqs\_arn) | The ARN of the Data Egress SQS Queue. | `string` | n/a | yes |
| <a name="input_data_egress_sqs_url"></a> [data\_egress\_sqs\_url](#input\_data\_egress\_sqs\_url) | The queue to which notifications of exported RIS files are sent. | `string` | n/a | yes |
| <a name="input_data_pipeline_metadata_arn"></a> [data\_pipeline\_metadata\_arn](#input\_data\_pipeline\_metadata\_arn) | The ARN of the data\_pipeline\_metadata table. | `string` | n/a | yes |
| <a name="input_data_pipeline_metadata_name"></a> [data\_pipeline\_metadata\_name](#input\_data\_pipeline\_metadata\_name) | The name of the data\_pipeline\_metadata table. | `string` | n/a | yes |
| <a name="input_default_ebs_cmk_arn"></a> [default\_ebs\_cmk\_arn](#input\_default\_ebs\_cmk\_arn) | The ARN of the KMS Key belonging to default EBS Volumes. | `string` | n/a | yes |
| <a name="input_directory_output"></a> [directory\_output](#input\_directory\_output) | Output directoy when in local output mode. | `string` | `"/tmp/hbase-export"` | no |
| <a name="input_dks_endpoint"></a> [dks\_endpoint](#input\_dks\_endpoint) | The endpoint of the Data Key Service. | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name of the infrastructure HTME will be deployed to. | `string` | n/a | yes |
| <a name="input_ebs_size"></a> [ebs\_size](#input\_ebs\_size) | The size of the root volume for the HTME instances. | `string` | n/a | yes |
| <a name="input_ebs_type"></a> [ebs\_type](#input\_ebs\_type) | The type of EBS root volume for the HTME instances. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment to deploy to. | `string` | n/a | yes |
| <a name="input_export_state_fifo_sqs_arn"></a> [export\_state\_fifo\_sqs\_arn](#input\_export\_state\_fifo\_sqs\_arn) | The ARN of the Export State FIFO SQS Queue. | `string` | n/a | yes |
| <a name="input_export_state_fifo_sqs_key_arn"></a> [export\_state\_fifo\_sqs\_key\_arn](#input\_export\_state\_fifo\_sqs\_key\_arn) | The ARN of the KMS Key belonging to the Export State FIFO SQS Queue. | `string` | n/a | yes |
| <a name="input_export_status_sns_fulls_arn"></a> [export\_status\_sns\_fulls\_arn](#input\_export\_status\_sns\_fulls\_arn) | The ARN of the export status SNS queue for full exports. | `string` | n/a | yes |
| <a name="input_export_status_sns_incrementals_arn"></a> [export\_status\_sns\_incrementals\_arn](#input\_export\_status\_sns\_incrementals\_arn) | The ARN of the export status SNS queue for incremental exports. | `string` | n/a | yes |
| <a name="input_fallback_instance_type"></a> [fallback\_instance\_type](#input\_fallback\_instance\_type) | The instance type to use for the fallback HTME. | `string` | n/a | yes |
| <a name="input_hbase_client_scanner_timeout_ms"></a> [hbase\_client\_scanner\_timeout\_ms](#input\_hbase\_client\_scanner\_timeout\_ms) | The timeout of the server side (per client can overwrite) for a scanner to complete its work. | `string` | `"600000"` | no |
| <a name="input_hbase_master_url"></a> [hbase\_master\_url](#input\_hbase\_master\_url) | The URL of the HBASE Master HTME should read from. | `string` | n/a | yes |
| <a name="input_hbase_rpc_read_timeout_ms"></a> [hbase\_rpc\_read\_timeout\_ms](#input\_hbase\_rpc\_read\_timeout\_ms) | The timeout of the server side (per client can overwrite) for a single RPC read only call. | `string` | `"600000"` | no |
| <a name="input_hbase_rpc_timeout_ms"></a> [hbase\_rpc\_timeout\_ms](#input\_hbase\_rpc\_timeout\_ms) | The timeout of the server side (per client can overwrite) for a single RPC call. | `string` | `"600000"` | no |
| <a name="input_health_check_grace_period"></a> [health\_check\_grace\_period](#input\_health\_check\_grace\_period) | Time (in seconds) after instance comes into service before checking health. | `number` | `600` | no |
| <a name="input_health_check_type"></a> [health\_check\_type](#input\_health\_check\_type) | EC2 or ELB. Controls how health checking is done. | `string` | `"EC2"` | no |
| <a name="input_host_truststore_aliases"></a> [host\_truststore\_aliases](#input\_host\_truststore\_aliases) | The alias of the CA certificates HTME should trust. | `string` | n/a | yes |
| <a name="input_host_truststore_certs"></a> [host\_truststore\_certs](#input\_host\_truststore\_certs) | The location of the CA certificates. | `string` | n/a | yes |
| <a name="input_htme_alert_on_collection_duration"></a> [htme\_alert\_on\_collection\_duration](#input\_htme\_alert\_on\_collection\_duration) | Whether to enable alerting on log messages indicating long running HTME Batch Jobs. | `bool` | `true` | no |
| <a name="input_htme_alert_on_dks_errors"></a> [htme\_alert\_on\_dks\_errors](#input\_htme\_alert\_on\_dks\_errors) | Whether to enable alerting on DKS Error log messages. | `bool` | `true` | no |
| <a name="input_htme_alert_on_dks_retries"></a> [htme\_alert\_on\_dks\_retries](#input\_htme\_alert\_on\_dks\_retries) | Whether to enable alerting on 50 or more DKS Error log messages found in 15 minutes | `bool` | `true` | no |
| <a name="input_htme_alert_on_failed_collections"></a> [htme\_alert\_on\_failed\_collections](#input\_htme\_alert\_on\_failed\_collections) | Whether to enable alerting on log messages indicating 1 or more failed collections found in 1 hour. | `bool` | `true` | no |
| <a name="input_htme_alert_on_failed_manifest_writes"></a> [htme\_alert\_on\_failed\_manifest\_writes](#input\_htme\_alert\_on\_failed\_manifest\_writes) | Whether to enable alerting on failed manifest writes log messages. | `bool` | `true` | no |
| <a name="input_htme_alert_on_failed_snapshots"></a> [htme\_alert\_on\_failed\_snapshots](#input\_htme\_alert\_on\_failed\_snapshots) | Whether to enable alerting on log messages indicating 5 or more failed snapshot writes found in 30 minutes. | `bool` | `true` | no |
| <a name="input_htme_alert_on_failed_to_start"></a> [htme\_alert\_on\_failed\_to\_start](#input\_htme\_alert\_on\_failed\_to\_start) | Whether to enable alerting on failed to start log messages. | `bool` | `true` | no |
| <a name="input_htme_alert_on_memory_usage"></a> [htme\_alert\_on\_memory\_usage](#input\_htme\_alert\_on\_memory\_usage) | Whether to enable alerting when HTME is using >90% of available memory. | `bool` | `true` | no |
| <a name="input_htme_alert_on_read_failures"></a> [htme\_alert\_on\_read\_failures](#input\_htme\_alert\_on\_read\_failures) | Whether to enable alerting on log messages indicating 5 or more HBase read errors found in 30 minutes. | `bool` | `true` | no |
| <a name="input_htme_alert_on_rejected_records"></a> [htme\_alert\_on\_rejected\_records](#input\_htme\_alert\_on\_rejected\_records) | Whether to enable alerting on log messages indicating 5 or more rejected records found in 30 minutes. | `bool` | `true` | no |
| <a name="input_htme_default_topics_ris_file_name"></a> [htme\_default\_topics\_ris\_file\_name](#input\_htme\_default\_topics\_ris\_file\_name) | The default CSV File to use per environment for ris topics. | `string` | n/a | yes |
| <a name="input_htme_log_level"></a> [htme\_log\_level](#input\_htme\_log\_level) | The log level of HTME. | `string` | `"INFO"` | no |
| <a name="input_htme_pushgateway_hostname"></a> [htme\_pushgateway\_hostname](#input\_htme\_pushgateway\_hostname) | The hostname of the HTME Prometheus Pushgateway. | `string` | n/a | yes |
| <a name="input_htme_version"></a> [htme\_version](#input\_htme\_version) | Hbase to Mongo export JAR release version. | `string` | n/a | yes |
| <a name="input_iam_role_max_session_timeout_seconds"></a> [iam\_role\_max\_session\_timeout\_seconds](#input\_iam\_role\_max\_session\_timeout\_seconds) | Timeout in seconds for an IAM Role to be assumed. | `number` | `43200` | no |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | The ID AMI to use to launch the instance. | `string` | n/a | yes |
| <a name="input_input_bucket_cmk_arn"></a> [input\_bucket\_cmk\_arn](#input\_input\_bucket\_cmk\_arn) | The KMS Key ARN belonging to the input S3 bucket. | `string` | n/a | yes |
| <a name="input_inspector"></a> [inspector](#input\_inspector) | Enabled inspector assessment. | `string` | `"disabled"` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | The name of the HTME instances held within the ASG. | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type to use for HTME. | `string` | n/a | yes |
| <a name="input_internet_proxy_dns_name"></a> [internet\_proxy\_dns\_name](#input\_internet\_proxy\_dns\_name) | The DNS Name of the internet proxy VPC Endpoint. | `string` | n/a | yes |
| <a name="input_logging_sh_content_hash"></a> [logging\_sh\_content\_hash](#input\_logging\_sh\_content\_hash) | The content as a hash of the logging script to deploy to HTME. | `string` | n/a | yes |
| <a name="input_manifest_bucket_cmk_arn"></a> [manifest\_bucket\_cmk\_arn](#input\_manifest\_bucket\_cmk\_arn) | The KMS Key ARN belonging to the compaction S3 bucket. | `string` | n/a | yes |
| <a name="input_manifest_retry_delay_ms"></a> [manifest\_retry\_delay\_ms](#input\_manifest\_retry\_delay\_ms) | The time to wait in ms before retrying a write to the manifest bucket. | `number` | `1000` | no |
| <a name="input_manifest_retry_max_attempts"></a> [manifest\_retry\_max\_attempts](#input\_manifest\_retry\_max\_attempts) | The number of retries to attempt to write to the manifest bucket before giving up. | `number` | `2` | no |
| <a name="input_manifest_retry_multiplier"></a> [manifest\_retry\_multiplier](#input\_manifest\_retry\_multiplier) | The backoff multiplier (the retry delay is this multiple of the previous delay) for retrying writes to the manifest bucket. | `number` | `2` | no |
| <a name="input_max_memory_allocation"></a> [max\_memory\_allocation](#input\_max\_memory\_allocation) | The Max memory allocation for heap. | `string` | `"NOT_SET"` | no |
| <a name="input_message_delay_seconds"></a> [message\_delay\_seconds](#input\_message\_delay\_seconds) | n/a | `number` | `1` | no |
| <a name="input_non_proxied_endpoints"></a> [non\_proxied\_endpoints](#input\_non\_proxied\_endpoints) | A string of service endpoints delimited by a comma (','). | `string` | n/a | yes |
| <a name="input_output_batch_size_max_bytes"></a> [output\_batch\_size\_max\_bytes](#input\_output\_batch\_size\_max\_bytes) | Max size in bytes of output chunks. | `string` | `"1073741824"` | no |
| <a name="input_pdm_common_model_site_prefix"></a> [pdm\_common\_model\_site\_prefix](#input\_pdm\_common\_model\_site\_prefix) | n/a | `string` | `"common-model-inputs/data/site/pipeline_success.flag"` | no |
| <a name="input_public_cert_bucket_arn"></a> [public\_cert\_bucket\_arn](#input\_public\_cert\_bucket\_arn) | The S3 Bucket ARN for public certificates. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Name of the region to deploy to. | `string` | n/a | yes |
| <a name="input_root_ca_arn"></a> [root\_ca\_arn](#input\_root\_ca\_arn) | The ARN of the root CA certificate. | `string` | n/a | yes |
| <a name="input_s3_artefact_bucket_arn"></a> [s3\_artefact\_bucket\_arn](#input\_s3\_artefact\_bucket\_arn) | The ARN of the artifact S3 bucket. | `string` | n/a | yes |
| <a name="input_s3_artefact_bucket_id"></a> [s3\_artefact\_bucket\_id](#input\_s3\_artefact\_bucket\_id) | The ID of the artifact S3 bucket. | `string` | n/a | yes |
| <a name="input_s3_compaction_bucket_arn"></a> [s3\_compaction\_bucket\_arn](#input\_s3\_compaction\_bucket\_arn) | The ARN of the compaction S3 bucket. | `string` | n/a | yes |
| <a name="input_s3_compaction_bucket_id"></a> [s3\_compaction\_bucket\_id](#input\_s3\_compaction\_bucket\_id) | The ID of the compaction S3 bucket. | `string` | n/a | yes |
| <a name="input_s3_config_bucket_arn"></a> [s3\_config\_bucket\_arn](#input\_s3\_config\_bucket\_arn) | The ARN of the config S3 bucket. | `string` | n/a | yes |
| <a name="input_s3_config_bucket_id"></a> [s3\_config\_bucket\_id](#input\_s3\_config\_bucket\_id) | The ID of the config S3 bucket. | `string` | n/a | yes |
| <a name="input_s3_manifest_bucket_arn"></a> [s3\_manifest\_bucket\_arn](#input\_s3\_manifest\_bucket\_arn) | The ARN of the manifest S3 bucket. | `string` | n/a | yes |
| <a name="input_s3_manifest_bucket_id"></a> [s3\_manifest\_bucket\_id](#input\_s3\_manifest\_bucket\_id) | The ID of the manifest S3 bucket. | `string` | n/a | yes |
| <a name="input_s3_manifest_prefix"></a> [s3\_manifest\_prefix](#input\_s3\_manifest\_prefix) | The prefix of the S3 manifest bucket. | `string` | n/a | yes |
| <a name="input_s3_script_common_logging_sh_id"></a> [s3\_script\_common\_logging\_sh\_id](#input\_s3\_script\_common\_logging\_sh\_id) | The ID of the S3 bucket holding the common logging script. | `string` | n/a | yes |
| <a name="input_s3_script_logging_sh_id"></a> [s3\_script\_logging\_sh\_id](#input\_s3\_script\_logging\_sh\_id) | The ID of the S3 bucket holding the logging script. | `string` | n/a | yes |
| <a name="input_s3_socket_timeout_milliseconds"></a> [s3\_socket\_timeout\_milliseconds](#input\_s3\_socket\_timeout\_milliseconds) | How long HTME should wait for an s3 connection before giving up | `string` | `"180000"` | no |
| <a name="input_scan_max_result_size"></a> [scan\_max\_result\_size](#input\_scan\_max\_result\_size) | The maximum number of rows to place in the client side cache. Default is unlimited. | `string` | `"-1"` | no |
| <a name="input_scan_width"></a> [scan\_width](#input\_scan\_width) | How much of the keyspace each scanner should scan. | `string` | `"2"` | no |
| <a name="input_scheduler_sqs_queue_name"></a> [scheduler\_sqs\_queue\_name](#input\_scheduler\_sqs\_queue\_name) | The name of the scheduler SQS Queue. | `string` | n/a | yes |
| <a name="input_sns_topic_arn_completion_full"></a> [sns\_topic\_arn\_completion\_full](#input\_sns\_topic\_arn\_completion\_full) | The ARN of the SNS topic to send the adg triggering message for full exports. | `string` | n/a | yes |
| <a name="input_sns_topic_arn_completion_incremental"></a> [sns\_topic\_arn\_completion\_incremental](#input\_sns\_topic\_arn\_completion\_incremental) | The ARN of the SNS topic to send the adg triggering message for incremental exports. | `string` | n/a | yes |
| <a name="input_sns_topic_arn_monitoring_arn"></a> [sns\_topic\_arn\_monitoring\_arn](#input\_sns\_topic\_arn\_monitoring\_arn) | The ARN of the monitoring topic to send alerts and notifcations to. | `string` | n/a | yes |
| <a name="input_spring_profiles"></a> [spring\_profiles](#input\_spring\_profiles) | Specifies the spring profiles to pass to the HTME application. | `string` | `"aesCipherService,secureHttpClient,httpDataKeyService,realHbaseDataSource,awsConfiguration,outputToS3,batchRun,weakRng,gzCompressor"` | no |
| <a name="input_sqs_messages_group_id_retries"></a> [sqs\_messages\_group\_id\_retries](#input\_sqs\_messages\_group\_id\_retries) | The SQS message group ID that failed topic retry messages should be sent to. | `string` | `"retried_collection_exports"` | no |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | A list of subnet CIDR addresses that HTME should be deployed into. | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of subnet IDs that HTME should be deployed into. | `list(string)` | n/a | yes |
| <a name="input_suspended_processes"></a> [suspended\_processes](#input\_suspended\_processes) | A list of processes to suspend for the Auto Scaling Group. The allowed values are Launch, Terminate, HealthCheck, ReplaceUnhealthy, AZRebalance, AlarmNotification, ScheduledActions, AddToLoadBalancer. We default to AZRebalance as we don't want to suspend HTME instances mid running due to uneven instances across AZs. | `list(string)` | <pre>[<br>  "AZRebalance"<br>]</pre> | no |
| <a name="input_uc_export_to_crown_status_table_arn"></a> [uc\_export\_to\_crown\_status\_table\_arn](#input\_uc\_export\_to\_crown\_status\_table\_arn) | The ARN of the uc\_export\_to\_crown\_status table. | `string` | n/a | yes |
| <a name="input_uc_export_to_crown_status_table_name"></a> [uc\_export\_to\_crown\_status\_table\_name](#input\_uc\_export\_to\_crown\_status\_table\_name) | The name of the uc\_export\_to\_crown\_status table. | `string` | n/a | yes |
| <a name="input_use_block_cache"></a> [use\_block\_cache](#input\_use\_block\_cache) | Whether HTME should enable scan cache blocks on the hbase scanner | `string` | `"false"` | no |
| <a name="input_use_timeline_consistency"></a> [use\_timeline\_consistency](#input\_use\_timeline\_consistency) | Whether HTME should scan the region replicas or only the master. Default of false means strong consistency. | `string` | `"false"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to deploy HTME into. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_htme_default_topics_csv"></a> [htme\_default\_topics\_csv](#output\_htme\_default\_topics\_csv) | n/a |
<!-- END_TF_DOCS -->