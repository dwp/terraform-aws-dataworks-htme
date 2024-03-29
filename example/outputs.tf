output "terratest_uc_export_crown_dynamodb_table" {
  description = "terratest export dynamo table"
  value       = aws_dynamodb_table.terratest_uc_export_to_crown_status_table
}

output "terratest_data_pipeline_metadata_dynamo" {
  description = "terratest pipeline dynamo table"
  value = {
    name = aws_dynamodb_table.terratest_data_pipeline_metadata.name
    arn  = aws_dynamodb_table.terratest_data_pipeline_metadata.arn
  }
}

output "compaction_bucket" {
  description = "Compaction Bucket maps"
  value = {
    id  = aws_s3_bucket.compaction.id
    arn = aws_s3_bucket.compaction.arn
  }
}

output "compaction_bucket_cmk" {
  description = "Compaction key maps"
  value = {
    arn = aws_kms_key.compaction_bucket_cmk.arn
  }
}

output "manifest_bucket" {
  description = "Manifest Bucket maps"
  value = {
    id                                         = aws_s3_bucket.manifest_bucket.id
    arn                                        = aws_s3_bucket.manifest_bucket.arn
    streaming_manifest_lifecycle_name_main     = local.manifest_s3_bucket_streaming_manifest_lifecycle_rule_name_main
    streaming_manifest_lifecycle_name_equality = local.manifest_s3_bucket_streaming_manifest_lifecycle_rule_name_equality
  }
}

output "manifest_bucket_cmk" {
  description = "Manifest key maps"
  value = {
    arn = aws_kms_key.manifest_bucket_cmk.arn
  }
}

output "uc_export_to_crown_completion_status_sns_topic" {
  description = "SNS Topic maps"
  value = {
    arn  = aws_sns_topic.export_status_sns_fulls.arn
    name = aws_sns_topic.export_status_sns_fulls.name
  }
}

output "export_status_sns_fulls" {
  description = "SNS Topic maps"
  value = {
    arn  = aws_sns_topic.export_status_sns_fulls.arn
    name = aws_sns_topic.export_status_sns_fulls.name
  }
}

output "uc_export_to_crown_completion_status_incrementals_sns_topic" {
  description = "SNS Topic maps"
  value = {
    arn  = aws_sns_topic.export_status_sns_incrementals.arn
    name = aws_sns_topic.export_status_sns_incrementals.name
  }
}

output "export_status_sns_incrementals" {
  description = "SNS Topic maps"
  value = {
    arn  = aws_sns_topic.export_status_sns_incrementals.arn
    name = aws_sns_topic.export_status_sns_incrementals.name
  }
}


output "sg_id" {
  value       = module.terratest_htme.sg_id
  description = "HTME security group ID."
}

output "asg_name" {
  value       = module.terratest_htme.asg_name
  description = "HTME Auto-scaling group name."
}
