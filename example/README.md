

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.53.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.53.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_terratest_htme"></a> [terratest\_htme](#module\_terratest\_htme) | ../ | n/a |
| <a name="module_terratest_htme_vpc"></a> [terratest\_htme\_vpc](#module\_terratest\_htme\_vpc) | dwp/vpc/aws | 3.0.23 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.acm_cert_retriever](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.application](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.bootstrapping](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.htme](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.system](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.uc_export_to_crown_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_dynamodb_table.terratest_data_pipeline_metadata](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_dynamodb_table.terratest_uc_export_to_crown_status_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_dynamodb_table_item.terratest_data_pipeline_metadata_item](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table_item) | resource |
| [aws_kms_alias.compaction_bucket_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.manifest_bucket_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.compaction_bucket_cmk](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.manifest_bucket_cmk](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.compaction](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.manifest_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_object.htme_default_topics_ris_csv](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [aws_s3_object.logging_script](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [aws_s3_bucket_policy.compaction](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.manifest_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.compaction](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.manifest_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_security_group.terratest_internet_proxy_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_service_discovery_private_dns_namespace.htme_services](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_private_dns_namespace) | resource |
| [aws_service_discovery_service.htme_services](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_service) | resource |
| [aws_sns_topic.export_status_sns_fulls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic.export_status_sns_incrementals](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.export_status_sns_fulls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_policy.export_status_sns_incrementals](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_subnet.htme](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.terratest_vpc_endpoints](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc_endpoint.internet_proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_iam_policy_document.compaction_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.export_status_sns_fulls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.export_status_sns_incrementals](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.manifest_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_sqs_queue.corporate_storage_export_sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/sqs_queue) | data source |
| [aws_sqs_queue.scheduler_sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/sqs_queue) | data source |
| [local_file.htme_default_topics_ris_csv](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
| [local_file.logging_script](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_al2_hardened_ami_id"></a> [al2\_hardened\_ami\_id](#input\_al2\_hardened\_ami\_id) | The AMI ID of the latest/pinned Hardened AMI AL2 Image | `string` | n/a | yes |
| <a name="input_assume_role"></a> [assume\_role](#input\_assume\_role) | Role to assume | `string` | `"ci"` | no |
| <a name="input_dataworks_domain_name"></a> [dataworks\_domain\_name](#input\_dataworks\_domain\_name) | Domain name | `string` | n/a | yes |
| <a name="input_htme_s3_prefix"></a> [htme\_s3\_prefix](#input\_htme\_s3\_prefix) | Prefix name on S3 target bucket where the HTME will export data | `string` | `"businessdata/mongo/ucdata"` | no |
| <a name="input_htme_version"></a> [htme\_version](#input\_htme\_version) | Hbase to Mongo export JAR release version | `string` | n/a | yes |
| <a name="input_mgmt_account"></a> [mgmt\_account](#input\_mgmt\_account) | Mgmt AWS Account number | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region | `string` | `"eu-west-1"` | no |
| <a name="input_state_file_bucket"></a> [state\_file\_bucket](#input\_state\_file\_bucket) | State file bucket | `string` | n/a | yes |
| <a name="input_state_file_kms_key"></a> [state\_file\_kms\_key](#input\_state\_file\_kms\_key) | State file key | `string` | n/a | yes |
| <a name="input_state_file_region"></a> [state\_file\_region](#input\_state\_file\_region) | State file region | `string` | n/a | yes |
| <a name="input_test_account"></a> [test\_account](#input\_test\_account) | Test AWS Account number | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_asg_name"></a> [asg\_name](#output\_asg\_name) | HTME Auto-scaling group name. |
| <a name="output_compaction_bucket"></a> [compaction\_bucket](#output\_compaction\_bucket) | Compaction Bucket maps |
| <a name="output_compaction_bucket_cmk"></a> [compaction\_bucket\_cmk](#output\_compaction\_bucket\_cmk) | Compaction key maps |
| <a name="output_export_status_sns_fulls"></a> [export\_status\_sns\_fulls](#output\_export\_status\_sns\_fulls) | SNS Topic maps |
| <a name="output_export_status_sns_incrementals"></a> [export\_status\_sns\_incrementals](#output\_export\_status\_sns\_incrementals) | SNS Topic maps |
| <a name="output_manifest_bucket"></a> [manifest\_bucket](#output\_manifest\_bucket) | Manifest Bucket maps |
| <a name="output_manifest_bucket_cmk"></a> [manifest\_bucket\_cmk](#output\_manifest\_bucket\_cmk) | Manifest key maps |
| <a name="output_sg_id"></a> [sg\_id](#output\_sg\_id) | HTME security group ID. |
| <a name="output_terratest_data_pipeline_metadata_dynamo"></a> [terratest\_data\_pipeline\_metadata\_dynamo](#output\_terratest\_data\_pipeline\_metadata\_dynamo) | terratest pipeline dynamo table |
| <a name="output_terratest_uc_export_crown_dynamodb_table"></a> [terratest\_uc\_export\_crown\_dynamodb\_table](#output\_terratest\_uc\_export\_crown\_dynamodb\_table) | terratest export dynamo table |
| <a name="output_uc_export_to_crown_completion_status_incrementals_sns_topic"></a> [uc\_export\_to\_crown\_completion\_status\_incrementals\_sns\_topic](#output\_uc\_export\_to\_crown\_completion\_status\_incrementals\_sns\_topic) | SNS Topic maps |
| <a name="output_uc_export_to_crown_completion_status_sns_topic"></a> [uc\_export\_to\_crown\_completion\_status\_sns\_topic](#output\_uc\_export\_to\_crown\_completion\_status\_sns\_topic) | SNS Topic maps |
<!-- END_TF_DOCS -->
