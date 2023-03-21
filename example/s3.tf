resource "aws_s3_object" "logging_script" {
  bucket     = data.terraform_remote_state.common.outputs.config_bucket.id
  key        = "component/shared/logging.sh"
  content    = data.local_file.logging_script.content
  kms_key_id = data.terraform_remote_state.common.outputs.config_bucket_cmk.arn
}

resource "aws_s3_object" "htme_default_topics_ris_csv" {
  bucket     = data.terraform_remote_state.common.outputs.config_bucket.id
  key        = "component/htme/htme_default_topics_ris.csv"
  content    = data.local_file.htme_default_topics_ris_csv.content
  kms_key_id = data.terraform_remote_state.common.outputs.config_bucket_cmk.arn
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
  bucket = "terratest-compaction-bucket"
  tags = merge(
    local.common_tags,
    {
      Name = "terratest_compaction_bucket"
    },
  )

}

resource "aws_s3_bucket_acl" "compaction" {
  bucket = aws_s3_bucket.compaction.id
  acl    = "private"
}


resource "aws_s3_bucket_lifecycle_configuration" "compaction" {
  bucket = aws_s3_bucket.compaction.id
  rule {
    id = "DeleteNonCurrentVersion"
    filter {
      prefix = ""
    }
    noncurrent_version_expiration {
      noncurrent_days = 1
    }

    status = "Enabled"
  }

  rule {
    id = "DeleteSnapshotSender"
    filter {
      prefix = "businessdata/mongo/snapshot-sender-status/"
    }
    expiration {
      days = 2
    }

    status = "Enabled"
  }

  rule {
    id = "DeleteCryptoDataAfterOneDay"
    filter {
      prefix = "businessdata/mongo/ucdata/*/*/db.crypto"
    }
    expiration {
      days = 1
    }

    status = "Enabled"
  }

  rule {
    id = "DeleteOldSnapshots"
    filter {
      prefix = "${var.htme_s3_prefix}/"
    }
    expiration {
      days = 7
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "compaction" {
  bucket = aws_s3_bucket.compaction.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "compaction" {
  bucket = aws_s3_bucket.compaction.id

  target_bucket = data.terraform_remote_state.security_tools.outputs.logstore_bucket.id
  target_prefix = "S3Logs/terratest-compaction-bucket/ServerLogs"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "compaction" {
  bucket = aws_s3_bucket.compaction.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.compaction_bucket_cmk.arn
      sse_algorithm     = "aws:kms"
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
  bucket = "terratest-manifest-bucket"

  tags = merge(
    local.common_tags,
    {
      Name = "terratest_manifest_bucket"
    },
  )

}

resource "aws_s3_bucket_acl" "manifest_bucket" {
  bucket = aws_s3_bucket.manifest_bucket.id
  acl    = "private"
}


resource "aws_s3_bucket_lifecycle_configuration" "manifest_bucket" {
  bucket = aws_s3_bucket.manifest_bucket.id
  rule {
    id = local.manifest_s3_bucket_streaming_manifest_lifecycle_rule_name_main
    filter {
      prefix = "${data.terraform_remote_state.ingestion.outputs.k2hb_manifest_write_locations.main_prefix}/"
    }
    expiration {
      days = 2
    }

    status = "Enabled"
  }

  rule {
    id = local.manifest_s3_bucket_streaming_manifest_lifecycle_rule_name_equality
    filter {
      prefix = "${data.terraform_remote_state.ingestion.outputs.k2hb_manifest_write_locations.equality_prefix}/"
    }
    expiration {
      days = 2
    }

    status = "Enabled"
  }

  rule {
    id = local.manifest_s3_bucket_streaming_manifest_lifecycle_rule_name_audit
    filter {
      prefix = "${data.terraform_remote_state.ingestion.outputs.k2hb_manifest_write_locations.audit_prefix}/"
    }
    expiration {
      days = 2
    }

    status = "Enabled"
  }

  rule {
    id = local.manifest_s3_bucket_export_manifest_lifecycle_rule_name
    filter {
      prefix = "${local.htme_s3_manifest_prefix}/"
    }
    expiration {
      days = 2
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "manifest_bucket" {
  bucket = aws_s3_bucket.manifest_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_logging" "manifest_bucket" {
  bucket = aws_s3_bucket.manifest_bucket.id

  target_bucket = data.terraform_remote_state.security_tools.outputs.logstore_bucket.id
  target_prefix = "S3Logs/terratest-manifest-bucket/ServerLogs"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "manifest_bucket" {
  bucket = aws_s3_bucket.manifest_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.manifest_bucket_cmk.arn
      sse_algorithm     = "aws:kms"
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
