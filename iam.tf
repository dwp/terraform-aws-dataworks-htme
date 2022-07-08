data "aws_iam_policy_document" "htme_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "htme" {
  name                 = "htme"
  assume_role_policy   = data.aws_iam_policy_document.htme_policy.json
  max_session_duration = local.iam_role_max_session_timeout_seconds
  tags                 = var.common_tags
}

resource "aws_iam_instance_profile" "htme" {
  name = "htme"
  role = aws_iam_role.htme.name
}

data "aws_iam_policy_document" "htme_main" {
  statement {
    sid    = "AllowACM"
    effect = "Allow"

    actions = [
      "acm:*Certificate",
    ]

    resources = [
    aws_acm_certificate.htme.arn]
  }

  statement {
    sid    = "GetPublicCerts"
    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    resources = [
    data.terraform_remote_state.certificate_authority.outputs.public_cert_bucket.arn]
  }

  statement {
    sid    = "AccessCompactionBucketObj"
    effect = "Allow"

    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetObject",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
    ]

    resources = [
    "${aws_s3_bucket.compaction.arn}/*"]
  }

  statement {
    sid    = "AccessCompactionBucket"
    effect = "Allow"

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
    ]

    resources = [
    aws_s3_bucket.compaction.arn]
  }

  statement {
    sid    = "AllowKMSEncryptionOfCompactionS3Objects"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*",
    ]

    resources = [
      aws_kms_key.compaction_bucket_cmk.arn,
    ]
  }

  statement {
    sid    = "WriteManifestsInIngestionBucket"
    effect = "Allow"

    actions = [
      "s3:DeleteObject*",
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.manifest_bucket.arn}/${local.htme_s3_manifest_prefix}/*",
    ]
  }

  statement {
    sid    = "ListManifests"
    effect = "Allow"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.manifest_bucket.arn,
    ]
  }

  statement {
    sid    = "AllowKMSEncryptionOfS3ManifestBucketObj"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*",
    ]


    resources = [
      aws_kms_key.manifest_bucket_cmk.arn,
    ]
  }

  statement {
    sid    = "AllowKMSEncryptionOfS3BucketObj"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*",
    ]


    resources = [
      data.terraform_remote_state.ingestion.outputs.input_bucket_cmk.arn,
    ]
  }

  statement {
    sid    = "AllowSQSSendRetrievalAndDeletion"
    effect = "Allow"

    actions = [
      "sqs:ChangeMessageVisibility*",
      "sqs:DeleteMessage*",
      "sqs:ReceiveMessage",
      "sqs:GetQueueAttributes",
      "sqs:SendMessage*",
    ]

    resources = [
      data.terraform_remote_state.common.outputs.export_state_fifo_sqs.arn,
      data.terraform_remote_state.common.outputs.corporate_storage_export_sqs.arn,
      data.terraform_remote_state.common.outputs.data_egress_sqs.arn,
    ]
  }

  statement {
    sid    = "AllowKMSEncryptionOfSQSMessages"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*",
    ]

    resources = [
      data.terraform_remote_state.common.outputs.export_state_fifo_sqs.key_arn,
      data.terraform_remote_state.common.outputs.corporate_storage_export_sqs.key_arn,
    ]
  }

  statement {
    sid    = "AllowGetEMRClusterDetails"
    effect = "Allow"

    actions = [
      "elasticmapreduce:List*",
      "elasticmapreduce:Describe*",
    ]

    resources = [
    "*"]
  }

  statement {
    sid    = "AllowUseDefaultEbsCmk"
    effect = "Allow"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]


    resources = [
    data.terraform_remote_state.security-tools.outputs.ebs_cmk.arn]
  }

  statement {
    effect = "Allow"
    sid    = "AllowAccessToConfigBucket"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]


    resources = [
    data.terraform_remote_state.common.outputs.config_bucket.arn]
  }

  statement {
    effect = "Allow"
    sid    = "AllowAccessToConfigBucketObjects"

    actions = [
    "s3:GetObject"]

    resources = [
    "${data.terraform_remote_state.common.outputs.config_bucket.arn}/*"]
  }

  statement {
    sid    = "AllowKMSDecryptionOfS3BucketObj"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey",
    ]


    resources = [
    data.terraform_remote_state.common.outputs.config_bucket_cmk.arn]
  }

  statement {
    sid    = "AllowDescribeASGToCheckLaunchTemplate"
    effect = "Allow"
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeScalingActivities",
    ]
    resources = [
    "*"]
  }

  statement {
    sid    = "AllowDescribeEC2LaunchTemplatesToCheckLatestVersion"
    effect = "Allow"
    actions = [
    "ec2:DescribeLaunchTemplates"]
    resources = [
    "*"]
  }

  statement {
    sid    = "AllowInstanceToDetachFromASG"
    effect = "Allow"
    actions = [
      "autoscaling:DetachInstances",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:UpdateAutoScalingGroup",
    ]
    resources = [
    aws_autoscaling_group.htme.arn]
  }

  statement {
    sid    = "AllowAccessToArtefactBucket"
    effect = "Allow"
    actions = [
    "s3:GetBucketLocation"]

    resources = [
    data.terraform_remote_state.management_artefact.outputs.artefact_bucket.arn]
  }

  statement {
    sid    = "AllowPullFromArtefactBucket"
    effect = "Allow"
    actions = [
    "s3:GetObject"]
    resources = [
    "${data.terraform_remote_state.management_artefact.outputs.artefact_bucket.arn}/*"]
  }

  statement {
    sid    = "AllowDecryptArtefactBucket"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
    ]


    resources = [
    data.terraform_remote_state.management_artefact.outputs.artefact_bucket.cmk_arn]
  }

  statement {
    sid    = "AllowHTMEAccessToUcEccDynamoDb"
    effect = "Allow"

    actions = [
      "dynamodb:GetItem",
      "dynamodb:UpdateItem",
      "dynamodb:PutItem",
      "dynamodb:Scan",
      "dynamodb:GetRecords",
      "dynamodb:Query",
    ]

    resources = [
      aws_dynamodb_table.uc_export_to_crown_status_table.arn,
      aws_dynamodb_table.data_pipeline_metadata.arn
    ]
  }

  statement {
    sid    = "AllowHTMEAccessToUpdateEC2Tags"
    effect = "Allow"

    actions = [
      "ec2:ModifyInstanceMetadataOptions",
      "ec2:*Tags",
    ]
    resources = ["arn:aws:ec2:${var.region}:${local.account[var.environment]}:instance/*"]
  }

  statement {
    sid    = "PublishToSnsTopics"
    effect = "Allow"

    actions = ["SNS:Publish"]
    resources = [
      aws_sns_topic.export_status_sns_fulls.arn,
      aws_sns_topic.export_status_sns_incrementals.arn,
      data.terraform_remote_state.security-tools.outputs.sns_topic_london_monitoring.arn,
    ]
  }
}

resource "aws_iam_policy" "htme_main" {
  name        = "htme_emr"
  description = "Policy to allow access to EMR"
  policy      = data.aws_iam_policy_document.htme_main.json
}

resource "aws_iam_role_policy_attachment" "htme_emr" {
  role       = aws_iam_role.htme.name
  policy_arn = aws_iam_policy.htme_main.arn
}

resource "aws_iam_role_policy_attachment" "htme_cwasp" {
  role       = aws_iam_role.htme.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "htme_ssm" {
  role       = aws_iam_role.htme.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}