data "aws_iam_policy_document" "sqs_queue_cmk_policy" {
  statement {
    sid    = "EnableIAMUserPermission"
    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${local.account[local.environment]}:root",
        "arn:aws:iam::${local.account[local.environment]}:role/CrownNifi",
      ]
    }

    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid    = "AllowCloudWatchEventsToUseTheKey"
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "events.amazonaws.com",
        "lambda.amazonaws.com",
      ]
    }

    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey",
    ]

    resources = ["*"]
  }
}

resource "aws_kms_key" "export_state_fifo_cmk" {
  description             = "Export State Fifo SQS Master Key"
  deletion_window_in_days = 7
  is_enabled              = true
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.sqs_queue_cmk_policy.json

  tags = {
    Name                  = "export_state_fifo_sqs_key"
    ProtectsSensitiveData = "false"
  }
}

resource "aws_kms_alias" "export_state_fifo" {
  name          = "alias/export_state_fifo_sqs_cmk"
  target_key_id = aws_kms_key.export_state_fifo_cmk.key_id
}

resource "aws_sqs_queue" "export_state_fifo" {
  name                              = "export_state.fifo"
  kms_master_key_id                 = aws_kms_alias.export_state_fifo.name
  kms_data_key_reuse_period_seconds = 86400
  delay_seconds                     = local.export_state_sqs_queue_delay_seconds[local.environment]
  fifo_queue                        = true
  content_based_deduplication       = true
  deduplication_scope               = "messageGroup"
  fifo_throughput_limit             = "perMessageGroupId"

  tags = {
    Name = "export_state_fifo"
  }
}

resource "aws_kms_key" "corporate_storage_export_sqs_cmk" {
  description             = "Corporate Storage Export SQS Master Key"
  deletion_window_in_days = 7
  is_enabled              = true
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.sqs_queue_cmk_policy.json

  tags = {
    Name                  = "corporate_storage_export_sqs_cmk"
    ProtectsSensitiveData = "false"
  }
}

resource "aws_kms_alias" "corporate_storage_export" {
  name          = "alias/corporate_storage_export"
  target_key_id = aws_kms_key.corporate_storage_export_sqs_cmk.key_id
}

resource "aws_sqs_queue" "corporate_storage_export" {
  name                              = "corporate_storage_export.fifo"
  kms_master_key_id                 = aws_kms_alias.corporate_storage_export.name
  kms_data_key_reuse_period_seconds = 86400
  fifo_queue                        = true
  content_based_deduplication       = true

  tags = {
    Name = "corporate_storage_export"
  }
}

output "export_state_fifo_sqs" {
  description = "Export state FIFO queue"
  value = {
    arn     = aws_sqs_queue.export_state_fifo.arn
    name    = aws_sqs_queue.export_state_fifo.name
    id      = aws_sqs_queue.export_state_fifo.id
    key_arn = aws_kms_key.export_state_fifo_cmk.arn
  }
}

output "corporate_storage_export_sqs" {
  description = "Corporate state FIFO queue"
  value = {
    arn     = aws_sqs_queue.corporate_storage_export.arn
    name    = aws_sqs_queue.corporate_storage_export.name
    id      = aws_sqs_queue.corporate_storage_export.id
    key_arn = aws_kms_key.corporate_storage_export_sqs_cmk.arn
  }
}
