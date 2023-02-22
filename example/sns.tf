resource "aws_sns_topic" "export_status_sns_fulls" {
  name = "export_status_sns_fulls"

  tags = merge(
    local.common_tags,
    {
      "Name" = "export_status_sns_fulls"
    },
  )
}

resource "aws_sns_topic" "export_status_sns_incrementals" {
  name = "export_status_sns_incrementals"

  tags = merge(
    local.common_tags,
    {
      "Name" = "export_status_sns_incrementals"
    },
  )
}

resource "aws_sns_topic_policy" "export_status_sns_fulls" {
  arn    = aws_sns_topic.export_status_sns_fulls.arn
  policy = data.aws_iam_policy_document.export_status_sns_fulls.json
}

resource "aws_sns_topic_policy" "export_status_sns_incrementals" {
  arn    = aws_sns_topic.export_status_sns_incrementals.arn
  policy = data.aws_iam_policy_document.export_status_sns_incrementals.json
}

data "aws_iam_policy_document" "export_status_sns_fulls" {
  policy_id = "ExportStatusFullsSnsTopicPolicy"

  statement {
    sid = "DefaultPolicy"

    actions = [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic",
      "SNS:Subscribe",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish",
      "SNS:Receive",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        local.account[local.environment],
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.export_status_sns_fulls.arn,
    ]
  }
}

data "aws_iam_policy_document" "export_status_sns_incrementals" {
  policy_id = "ExportStatusIncrementalsSnsTopicPolicy"

  statement {
    sid = "DefaultPolicyIncrementals"

    actions = [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic",
      "SNS:Subscribe",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish",
      "SNS:Receive",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        local.account[local.environment],
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.export_status_sns_incrementals.arn,
    ]
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
