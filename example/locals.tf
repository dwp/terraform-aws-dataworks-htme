locals {

  common_tags = {
    DWX_Environment = local.environment
    DWX_Application = "terratest-aws-internal-compute"
    CreatedBy       = "terratest"
  }

  environment = terraform.workspace == "default" ? "development" : terraform.workspace

  account = {
    development = var.test_account
    management  = var.mgmt_account
  }
  hcs_environment = {
    development    = "Dev"
    qa             = "Test"
    integration    = "Stage"
    preprod        = "Stage"
    production     = "Production"
    management     = "SP_Tooling"
    management-dev = "DT_Tooling"
  }

  management_account = {
    development = "management-dev"
    qa          = "management-dev"
    integration = "management-dev"
    preprod     = "management"
    production  = "management"
  }

  crypto_workspace = {
    management-dev = "management-dev"
    management     = "management"
  }

  management_workspace = {
    management-dev = "default"
    management     = "management"
  }

  env_prefix = {
    development = "dev."
  }

  dw_domain = "terratest.${local.env_prefix[local.environment]}dataworks.dwp.gov.uk"

  cw_agent_namespace            = "/terratest/app/htme"
  cw_agent_controller_namespace = "/terratest/app/lambda/uc_export_to_crown_controller"

  cw_agent_log_group_name_htme         = "/terratest/app/htme"
  cw_agent_log_group_name_acm          = "/terratest/app/htme/acm"
  cw_agent_log_group_name_application  = "/terratest/app/htme/application"
  cw_agent_log_group_name_boostrapping = "/terratest/app/htme/boostrapping"
  cw_agent_log_group_name_system       = "/terratest/app/htme/system"
  cw_uc_export_to_crown_controller     = "/terratest/app/htme/uc_export_to_crown_controller"

  manifest_s3_bucket_streaming_manifest_lifecycle_rule_name_main     = "streaming-manifests-main"
  manifest_s3_bucket_streaming_manifest_lifecycle_rule_name_equality = "streaming-manifests-equality"
  manifest_s3_bucket_streaming_manifest_lifecycle_rule_name_audit    = "streaming-manifests-audit"
  manifest_s3_bucket_export_manifest_lifecycle_rule_name             = "export-manifests"

  htme_s3_manifest_prefix = "${data.terraform_remote_state.ingestion.outputs.manifest_s3_prefixes.base}/export"



}
