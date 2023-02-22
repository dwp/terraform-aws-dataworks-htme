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
  filename = "files/htme/htme_default_topics_ris/htme_default_topics_development.csv"
}

data "aws_secretsmanager_secret_version" "terraform_secrets" {
  provider  = aws.management_dns
  secret_id = "/concourse/dataworks/terraform"
}


data "terraform_remote_state" "aws_internal_compute" {
  backend   = "s3"
  workspace = terraform.workspace

  config = {
    bucket         = "39d01d46d48c2b153873f655835c77db"
    key            = "terraform/dataworks/aws-internal-compute.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    kms_key_id     = "arn:aws:kms:eu-west-1:024877303807:key/d4a5b5a0-a979-46ea-b6ae-041fa20d2315"
    dynamodb_table = "remote_state_locks"
  }
}

data "terraform_remote_state" "common" {
  backend   = "s3"
  workspace = terraform.workspace

  config = {
    bucket         = "39d01d46d48c2b153873f655835c77db"
    key            = "terraform/dataworks/common.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    kms_key_id     = "arn:aws:kms:eu-west-1:024877303807:key/d4a5b5a0-a979-46ea-b6ae-041fa20d2315"
    dynamodb_table = "remote_state_locks"
  }
}

data "terraform_remote_state" "security_tools" {
  backend   = "s3"
  workspace = terraform.workspace

  config = {
    bucket         = "39d01d46d48c2b153873f655835c77db"
    key            = "terraform/dataworks/aws-security-tools.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    kms_key_id     = "arn:aws:kms:eu-west-1:024877303807:key/d4a5b5a0-a979-46ea-b6ae-041fa20d2315"
    dynamodb_table = "remote_state_locks"
  }
}

data "terraform_remote_state" "ingestion" {
  backend   = "s3"
  workspace = terraform.workspace

  config = {
    bucket         = "39d01d46d48c2b153873f655835c77db"
    key            = "terraform/dataworks/aws-ingestion.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    kms_key_id     = "arn:aws:kms:eu-west-1:024877303807:key/d4a5b5a0-a979-46ea-b6ae-041fa20d2315"
    dynamodb_table = "remote_state_locks"
  }

}

data "terraform_remote_state" "crypto" {
  backend   = "s3"
  workspace = local.crypto_workspace[local.management_account[local.environment]]

  config = {
    bucket         = "39d01d46d48c2b153873f655835c77db"
    key            = "terraform/dataworks/aws-crypto.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    kms_key_id     = "arn:aws:kms:eu-west-1:024877303807:key/d4a5b5a0-a979-46ea-b6ae-041fa20d2315"
    dynamodb_table = "remote_state_locks"
  }
}

data "terraform_remote_state" "internet_egress" {
  backend   = "s3"
  workspace = local.management_workspace[local.management_account[local.environment]]

  config = {
    bucket         = "39d01d46d48c2b153873f655835c77db"
    key            = "terraform/dataworks/aws-internet-egress.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    kms_key_id     = "arn:aws:kms:eu-west-1:024877303807:key/d4a5b5a0-a979-46ea-b6ae-041fa20d2315"
    dynamodb_table = "remote_state_locks"
  }
}

data "terraform_remote_state" "internet_ingress" {
  backend   = "s3"
  workspace = local.management_workspace[local.management_account[local.environment]]

  config = {
    bucket         = "39d01d46d48c2b153873f655835c77db"
    key            = "terraform/dataworks/dataworks-internet-ingress.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    kms_key_id     = "arn:aws:kms:eu-west-1:024877303807:key/d4a5b5a0-a979-46ea-b6ae-041fa20d2315"
    dynamodb_table = "remote_state_locks"
  }
}

data "terraform_remote_state" "certificate_authority" {
  backend   = "s3"
  workspace = terraform.workspace

  config = {
    bucket         = "39d01d46d48c2b153873f655835c77db"
    key            = "terraform/dataworks/aws-certificate-authority.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    kms_key_id     = "arn:aws:kms:eu-west-1:024877303807:key/d4a5b5a0-a979-46ea-b6ae-041fa20d2315"
    dynamodb_table = "remote_state_locks"
  }
}

data "terraform_remote_state" "mgmt_ca" {
  backend   = "s3"
  workspace = local.management_account[local.environment]

  config = {
    bucket         = "39d01d46d48c2b153873f655835c77db"
    key            = "terraform/dataworks/aws-certificate-authority.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    kms_key_id     = "arn:aws:kms:eu-west-1:024877303807:key/d4a5b5a0-a979-46ea-b6ae-041fa20d2315"
    dynamodb_table = "remote_state_locks"
  }
}

data "terraform_remote_state" "management_artefact" {
  backend   = "s3"
  workspace = "management"

  config = {
    bucket         = "39d01d46d48c2b153873f655835c77db"
    key            = "terraform/dataworks/management.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    kms_key_id     = "arn:aws:kms:eu-west-1:024877303807:key/d4a5b5a0-a979-46ea-b6ae-041fa20d2315"
    dynamodb_table = "remote_state_locks"
  }
}

data "terraform_remote_state" "management_dns" {
  backend   = "s3"
  workspace = "management"

  config = {
    bucket         = "39d01d46d48c2b153873f655835c77db"
    key            = "terraform/dataworks/management.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    kms_key_id     = "arn:aws:kms:eu-west-1:024877303807:key/d4a5b5a0-a979-46ea-b6ae-041fa20d2315"
    dynamodb_table = "remote_state_locks"
  }
}
