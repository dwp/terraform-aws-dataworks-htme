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
