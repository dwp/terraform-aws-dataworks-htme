locals {

  common_tags = {
    DWX_Environment = local.environment
    DWX_Application = "terratest-aws-internal-compute"
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

  cw_agent_namespace            = "/terratest/app/htme"
  cw_agent_controller_namespace = "/terratest/app/lambda/uc_export_to_crown_controller"

  cw_agent_log_group_name_htme         = "/terratest/app/htme"
  cw_agent_log_group_name_acm          = "/terratest/app/htme/acm"
  cw_agent_log_group_name_application  = "/terratest/app/htme/application"
  cw_agent_log_group_name_boostrapping = "/terratest/app/htme/boostrapping"
  cw_agent_log_group_name_system       = "/terratest/app/htme/system"

}
