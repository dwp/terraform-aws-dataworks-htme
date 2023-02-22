resource "aws_s3_bucket_object" "logging_script" {
  bucket     = data.terraform_remote_state.common.outputs.config_bucket.id
  key        = "component/shared/logging.sh"
  content    = data.local_file.logging_script.content
  kms_key_id = data.terraform_remote_state.common.outputs.config_bucket_cmk.arn
}

resource "aws_s3_bucket_object" "htme_default_topics_ris_csv" {
  bucket     = data.terraform_remote_state.common.outputs.config_bucket.id
  key        = "component/htme/htme_default_topics_ris.csv"
  content    = data.local_file.htme_default_topics_ris_csv.content
  kms_key_id = data.terraform_remote_state.common.outputs.config_bucket_cmk.arn
}


resource "random_id" "compaction_bucket" {
  byte_length = 16
}

resource "aws_kms_key" "compaction_bucket_cmk" {
  description             = "Terratest Compaction Bucket Master Key"
  deletion_window_in_days = 7
  is_enabled              = true
  enable_key_rotation     = true

  tags = merge(
    local.common_tags,
    {
      "Name" = "terratest_compaction_bucket_cmk"
    },
    {
      "requires-custom-key-policy" = "false"
    },
  )
}

resource "aws_kms_alias" "compaction_bucket_alias" {
  name          = "alias/terratest_compaction_bucket"
  target_key_id = aws_kms_key.compaction_bucket_cmk.key_id
}

resource "aws_s3_bucket" "compaction" {
  bucket = random_id.compaction_bucket.hex
  acl    = "private"
  tags = merge(
    local.common_tags,
    {
      Name = "terratest_compaction_bucket"
    },
  )

  versioning {
    enabled = false
  }

  logging {
    target_bucket = data.terraform_remote_state.security-tools.outputs.logstore_bucket.id
    target_prefix = "S3Logs/${random_id.compaction_bucket.hex}/ServerLogs"
  }

  lifecycle_rule {
    id      = "DeleteNonCurrentVersion"
    prefix  = ""
    enabled = true

    noncurrent_version_expiration {
      days = 1
    }
  }

  lifecycle_rule {
    id      = "DeleteSnapshotSender"
    prefix  = "businessdata/mongo/snapshot-sender-status/"
    enabled = true

    expiration {
      days = 2
    }
  }

  lifecycle_rule {
    id      = "DeleteCryptoDataAfterOneDay"
    prefix  = "businessdata/mongo/ucdata/*/*/db.crypto"
    enabled = true

    expiration {
      days = 1
    }
  }

  lifecycle_rule {
    id      = "DeleteOldSnapshots"
    prefix  = "${var.htme_s3_prefix}/"
    enabled = true

    expiration {
      days = 7
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.compaction_bucket_cmk.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "compaction" {
  bucket = aws_s3_bucket.compaction.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

data "aws_iam_policy_document" "compaction_bucket" {
  statement {
    sid     = "BlockHTTP"
    effect  = "Deny"
    actions = ["*"]

    resources = [
      aws_s3_bucket.compaction.arn,
      "${aws_s3_bucket.compaction.arn}/*",
    ]

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }

    condition {
      test     = "Bool"
      values   = ["false"]
      variable = "aws:SecureTransport"
    }
  }

  statement {
    sid     = "DenyGetObjectOnCryptoCollectionsToAllExceptDataEgressRole"
    effect  = "Deny"
    actions = ["s3:GetObject"]

    resources = [
      "${aws_s3_bucket.compaction.arn}/businessdata/mongo/ucdata/*/*/db.crypto",
    ]

    not_principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account[local.environment]}:role/DataEgressServer"]
    }
  }
}

resource "aws_s3_bucket_policy" "compaction" {
  bucket = aws_s3_bucket.compaction.id
  policy = data.aws_iam_policy_document.compaction_bucket.json
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



resource "random_id" "manifest_bucket" {
  byte_length = 16
}

resource "aws_kms_key" "manifest_bucket_cmk" {
  description             = "Terratest Manifest Bucket Master Key"
  deletion_window_in_days = 7
  is_enabled              = true
  enable_key_rotation     = true

  tags = merge(
    local.common_tags,
    {
      Name                       = "terratest_manifest_bucket_cmk",
      requires-custom-key-policy = "false",
    },
  )
}

resource "aws_kms_alias" "manifest_bucket_alias" {
  name          = "alias/terratest_manifest_bucket"
  target_key_id = aws_kms_key.manifest_bucket_cmk.key_id
}

resource "aws_s3_bucket" "manifest_bucket" {
  bucket = random_id.manifest_bucket.hex
  acl    = "private"

  tags = merge(
    local.common_tags,
    {
      Name = "terratest_manifest_bucket"
    },
  )

  versioning {
    enabled = false
  }

  logging {
    target_bucket = data.terraform_remote_state.security-tools.outputs.logstore_bucket.id
    target_prefix = "S3Logs/${random_id.manifest_bucket.hex}/ServerLogs"
  }

  lifecycle_rule {
    id      = local.manifest_s3_bucket_streaming_manifest_lifecycle_rule_name_main
    prefix  = "${data.terraform_remote_state.ingestion.outputs.k2hb_manifest_write_locations.main_prefix}/"
    enabled = true

    expiration {
      days = 2
    }
  }

  lifecycle_rule {
    id      = local.manifest_s3_bucket_streaming_manifest_lifecycle_rule_name_equality
    prefix  = "${data.terraform_remote_state.ingestion.outputs.k2hb_manifest_write_locations.equality_prefix}/"
    enabled = true

    expiration {
      days = 2
    }
  }

  lifecycle_rule {
    id      = local.manifest_s3_bucket_streaming_manifest_lifecycle_rule_name_audit
    prefix  = "${data.terraform_remote_state.ingestion.outputs.k2hb_manifest_write_locations.audit_prefix}/"
    enabled = true

    expiration {
      days = 2
    }
  }

  lifecycle_rule {
    id      = local.manifest_s3_bucket_export_manifest_lifecycle_rule_name
    prefix  = "${local.htme_s3_manifest_prefix}/"
    enabled = true

    expiration {
      days = 2
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.manifest_bucket_cmk.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "manifest_bucket" {
  bucket = aws_s3_bucket.manifest_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

data "aws_iam_policy_document" "manifest_bucket" {
  statement {
    sid     = "BlockHTTP"
    effect  = "Deny"
    actions = ["*"]

    resources = [
      aws_s3_bucket.manifest_bucket.arn,
      "${aws_s3_bucket.manifest_bucket.arn}/*",
    ]

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }

    condition {
      test     = "Bool"
      values   = ["false"]
      variable = "aws:SecureTransport"
    }
  }
}

resource "aws_s3_bucket_policy" "manifest_bucket" {
  depends_on = [aws_s3_bucket_public_access_block.manifest_bucket]
  bucket     = aws_s3_bucket.manifest_bucket.id
  policy     = data.aws_iam_policy_document.manifest_bucket.json
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
