output "terratest_uc_export_crown_dynamodb_table" {
  type        = string
  description = "terratest export dynamo table"
  value       = aws_dynamodb_table.terratest_uc_export_to_crown_status_table
}

output "terratest_data_pipeline_metadata_dynamo" {
  type        = string
  description = "terratest pipeline dynamo table"
  value = {
    name = aws_dynamodb_table.terratest_data_pipeline_metadata.name
    arn  = aws_dynamodb_table.terratest_data_pipeline_metadata.arn
  }
}

output "compaction_bucket" {
  type        = map(string)
  description = "Compaction Bucket maps"
  value = {
    id  = aws_s3_bucket.compaction.id
    arn = aws_s3_bucket.compaction.arn
  }
}

output "compaction_bucket_cmk" {
  type        = map(string)
  description = "Compaction key maps"
  value = {
    arn = aws_kms_key.compaction_bucket_cmk.arn
  }
}

output "manifest_bucket" {
  type        = map(string)
  description = "Manifest Bucket maps"
  value = {
    id                                         = aws_s3_bucket.manifest_bucket.id
    arn                                        = aws_s3_bucket.manifest_bucket.arn
    streaming_manifest_lifecycle_name_main     = local.manifest_s3_bucket_streaming_manifest_lifecycle_rule_name_main
    streaming_manifest_lifecycle_name_equality = local.manifest_s3_bucket_streaming_manifest_lifecycle_rule_name_equality
  }
}

output "manifest_bucket_cmk" {
  type        = map(string)
  description = "Manifest key maps"
  value = {
    arn = aws_kms_key.manifest_bucket_cmk.arn
  }
}

output "uc_export_to_crown_completion_status_sns_topic" {
  type        = map(string)
  description = "SNS Topic maps"
  value = {
    arn  = aws_sns_topic.export_status_sns_fulls.arn
    name = aws_sns_topic.export_status_sns_fulls.name
  }
}

output "export_status_sns_fulls" {
  type        = map(string)
  description = "SNS Topic maps"
  value = {
    arn  = aws_sns_topic.export_status_sns_fulls.arn
    name = aws_sns_topic.export_status_sns_fulls.name
  }
}

output "uc_export_to_crown_completion_status_incrementals_sns_topic" {
  type        = map(string)
  description = "SNS Topic maps"
  value = {
    arn  = aws_sns_topic.export_status_sns_incrementals.arn
    name = aws_sns_topic.export_status_sns_incrementals.name
  }
}

output "export_status_sns_incrementals" {
  type        = map(string)
  description = "SNS Topic maps"
  value = {
    arn  = aws_sns_topic.export_status_sns_incrementals.arn
    name = aws_sns_topic.export_status_sns_incrementals.name
  }
}
