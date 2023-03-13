resource "aws_dynamodb_table" "terratest_uc_export_to_crown_status_table" {
  name         = "UCExportToCrownStatus"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "CorrelationId"
  range_key    = "CollectionName"

  attribute {
    name = "CorrelationId"
    type = "S"
  }

  attribute {
    name = "CollectionName"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = true
  }

  tags = merge(
    local.common_tags,
    tomap({
      Name = "terratestUCExportToCrownStatus"
    })
  )
}

resource "aws_dynamodb_table" "terratest_data_pipeline_metadata" {
  name         = "terratest_data_pipeline_metadata"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Correlation_Id"
  range_key    = "DataProduct"

  attribute {
    name = "Correlation_Id"
    type = "S"
  }

  attribute {
    name = "DataProduct"
    type = "S"
  }

  ttl {
    enabled        = true
    attribute_name = "TimeToExist"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "terratest_data_pipeline_metadata_dynamo"
    }
  )

}

resource "aws_dynamodb_table_item" "terratest_data_pipeline_metadata_item" {
  table_name = aws_dynamodb_table.terratest_data_pipeline_metadata.name
  hash_key   = aws_dynamodb_table.terratest_data_pipeline_metadata.hash_key
  range_key  = aws_dynamodb_table.terratest_data_pipeline_metadata.range_key

  item = <<ITEM
{
  "Correlation_Id": {"S": "init"},
  "DataProduct": {"S": "init"},
  "Run_Id": {"N": "0"},
  "Date": {"S": "init"},
  "CurrentStep": {"S": "init"},
  "Status": {"S": "init"},
  "Cluster_Id": {"S": "init"},
  "S3_Prefix": {"S": "init"}
}
ITEM
}
