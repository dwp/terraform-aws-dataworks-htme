locals {

  common_tags = {
    DWX_Environment = local.environment
    DWX_Application = "aws-internal-compute"
    CreatedBy       = "terratest"
  }

  environment = terraform.workspace == "default" ? "development" : terraform.workspace

  hcs_environment = {
    development    = "Dev"
    qa             = "Test"
    integration    = "Stage"
    preprod        = "Stage"
    production     = "Production"
    management     = "SP_Tooling"
    management-dev = "DT_Tooling"
  }

  env_prefix = {
    development = "dev."
  }

  dw_domain = "${local.env_prefix[local.environment]}dataworks.dwp.gov.uk"


}
