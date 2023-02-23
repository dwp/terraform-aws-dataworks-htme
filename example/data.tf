data "aws_sqs_queue" "scheduler_sqs" {
  name = data.terraform_remote_state.common.outputs.export_state_fifo_sqs.name
}

data "aws_sqs_queue" "corporate_storage_export_sqs" {
  name = data.terraform_remote_state.common.outputs.corporate_storage_export_sqs.name
}

data "local_file" "logging_script" {
  filename = "files/shared/logging.sh"
}

data "local_file" "htme_default_topics_ris_csv" {
  filename = "files/htme/htme_default_topics_ris/htme_default_topics_ris_development.csv"
}

data "terraform_remote_state" "aws_internal_compute" {
  backend   = "s3"
  workspace = terraform.workspace

  config = {
    bucket         = var.state_file_bucket
    key            = "terraform/dataworks/aws-internal-compute.tfstate"
    region         = var.state_file_region
    encrypt        = true
    kms_key_id     = "arn:aws:kms:${var.state_file_region}:${var.mgmt_account}:key/${var.state_file_kms_key}"
    dynamodb_table = "remote_state_locks"
  }
}

data "terraform_remote_state" "common" {
  backend   = "s3"
  workspace = terraform.workspace

  config = {
    bucket         = var.state_file_bucket
    key            = "terraform/dataworks/common.tfstate"
    region         = var.state_file_region
    encrypt        = true
    kms_key_id     = "arn:aws:kms:${var.state_file_region}:${var.mgmt_account}:key/${var.state_file_kms_key}"
    dynamodb_table = "remote_state_locks"
  }
}

data "terraform_remote_state" "security_tools" {
  backend   = "s3"
  workspace = terraform.workspace

  config = {
    bucket         = var.state_file_bucket
    key            = "terraform/dataworks/aws-security-tools.tfstate"
    region         = var.state_file_region
    encrypt        = true
    kms_key_id     = "arn:aws:kms:${var.state_file_region}:${var.mgmt_account}:key/${var.state_file_kms_key}"
    dynamodb_table = "remote_state_locks"
  }
}

data "terraform_remote_state" "ingestion" {
  backend   = "s3"
  workspace = terraform.workspace

  config = {
    bucket         = var.state_file_bucket
    key            = "terraform/dataworks/aws-ingestion.tfstate"
    region         = var.state_file_region
    encrypt        = true
    kms_key_id     = "arn:aws:kms:${var.state_file_region}:${var.mgmt_account}:key/${var.state_file_kms_key}"
    dynamodb_table = "remote_state_locks"
  }

}

data "terraform_remote_state" "crypto" {
  backend   = "s3"
  workspace = local.crypto_workspace[local.management_account[local.environment]]

  config = {
    bucket         = var.state_file_bucket
    key            = "terraform/dataworks/aws-crypto.tfstate"
    region         = var.state_file_region
    encrypt        = true
    kms_key_id     = "arn:aws:kms:${var.state_file_region}:${var.mgmt_account}:key/${var.state_file_kms_key}"
    dynamodb_table = "remote_state_locks"
  }
}

data "terraform_remote_state" "internet_egress" {
  backend   = "s3"
  workspace = local.management_workspace[local.management_account[local.environment]]

  config = {
    bucket         = var.state_file_bucket
    key            = "terraform/dataworks/aws-internet-egress.tfstate"
    region         = var.state_file_region
    encrypt        = true
    kms_key_id     = "arn:aws:kms:${var.state_file_region}:${var.mgmt_account}:key/${var.state_file_kms_key}"
    dynamodb_table = "remote_state_locks"
  }
}

data "terraform_remote_state" "internet_ingress" {
  backend   = "s3"
  workspace = local.management_workspace[local.management_account[local.environment]]

  config = {
    bucket         = var.state_file_bucket
    key            = "terraform/dataworks/dataworks-internet-ingress.tfstate"
    region         = var.state_file_region
    encrypt        = true
    kms_key_id     = "arn:aws:kms:${var.state_file_region}:${var.mgmt_account}:key/${var.state_file_kms_key}"
    dynamodb_table = "remote_state_locks"
  }
}

data "terraform_remote_state" "certificate_authority" {
  backend   = "s3"
  workspace = terraform.workspace

  config = {
    bucket         = var.state_file_bucket
    key            = "terraform/dataworks/aws-certificate-authority.tfstate"
    region         = var.state_file_region
    encrypt        = true
    kms_key_id     = "arn:aws:kms:${var.state_file_region}:${var.mgmt_account}:key/${var.state_file_kms_key}"
    dynamodb_table = "remote_state_locks"
  }
}

data "terraform_remote_state" "mgmt_ca" {
  backend   = "s3"
  workspace = local.management_account[local.environment]

  config = {
    bucket         = var.state_file_bucket
    key            = "terraform/dataworks/aws-certificate-authority.tfstate"
    region         = var.state_file_region
    encrypt        = true
    kms_key_id     = "arn:aws:kms:${var.state_file_region}:${var.mgmt_account}:key/${var.state_file_kms_key}"
    dynamodb_table = "remote_state_locks"
  }
}

data "terraform_remote_state" "management_artefact" {
  backend   = "s3"
  workspace = "management"

  config = {
    bucket         = var.state_file_bucket
    key            = "terraform/dataworks/management.tfstate"
    region         = var.state_file_region
    encrypt        = true
    kms_key_id     = "arn:aws:kms:${var.state_file_region}:${var.mgmt_account}:key/${var.state_file_kms_key}"
    dynamodb_table = "remote_state_locks"
  }
}

data "terraform_remote_state" "management_dns" {
  backend   = "s3"
  workspace = "management"

  config = {
    bucket         = var.state_file_bucket
    key            = "terraform/dataworks/management.tfstate"
    region         = var.state_file_region
    encrypt        = true
    kms_key_id     = "arn:aws:kms:${var.state_file_region}:${var.mgmt_account}:key/${var.state_file_kms_key}"
    dynamodb_table = "remote_state_locks"
  }
}


data "aws_availability_zones" "available" {
}
