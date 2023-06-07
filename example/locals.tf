locals {

  common_tags = {
    DWX_Environment = local.environment
    DWX_Application = "terratest-aws-internal-compute"
    CreatedBy       = "terratest"
  }

  environment = terraform.workspace == "default" ? "development" : terraform.workspace

  account = {
    development = var.test_account
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

  dw_domain = "terratest.${local.env_prefix[local.environment]}${var.dataworks_domain_name}"

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

  tenable_install = {
    development    = "true"
    qa             = "true"
    integration    = "true"
    preprod        = "true"
    production     = "true"
    management-dev = "true"
    management     = "true"
  }

  trend_install = {
    development    = "true"
    qa             = "true"
    integration    = "true"
    preprod        = "true"
    production     = "true"
    management-dev = "true"
    management     = "true"
  }

  tanium_install = {
    development    = "false"
    qa             = "false"
    integration    = "false"
    preprod        = "false"
    production     = "false"
    management-dev = "false"
    management     = "false"
  }


  ## Tanium config
  ## Tanium Servers
  tanium_server_1 = "10.0.0.1" # Dummy IP for testing
  tanium_server_2 = "10.0.0.2" # Dummy IP for testing

  ## Tanium Env Config
  tanium_env = {
    development    = "pre-prod"
    qa             = "prod"
    integration    = "prod"
    preprod        = "prod"
    production     = "prod"
    management-dev = "pre-prod"
    management     = "prod"
  }

  ## Tanium prefix list for TGW for Security Group rules
  tanium_prefix = {
    development    = [data.aws_ec2_managed_prefix_list.list.id]
    qa             = [data.aws_ec2_managed_prefix_list.list.id]
    integration    = [data.aws_ec2_managed_prefix_list.list.id]
    preprod        = [data.aws_ec2_managed_prefix_list.list.id]
    production     = [data.aws_ec2_managed_prefix_list.list.id]
    management-dev = [data.aws_ec2_managed_prefix_list.list.id]
    management     = [data.aws_ec2_managed_prefix_list.list.id]
  }

  tanium_log_level = {
    development    = "41"
    qa             = "41"
    integration    = "41"
    preprod        = "41"
    production     = "41"
    management-dev = "41"
    management     = "41"
  }

  ## Trend config
  tenant   = jsondecode(data.aws_secretsmanager_secret_version.terraform_secrets.secret_binary).trend.tenant
  tenantid = jsondecode(data.aws_secretsmanager_secret_version.terraform_secrets.secret_binary).trend.tenantid
  token    = jsondecode(data.aws_secretsmanager_secret_version.terraform_secrets.secret_binary).trend.token

  policyid = {
    development    = "69"
    qa             = "69"
    integration    = "69"
    preprod        = "69"
    production     = "69"
    management-dev = "69"
    management     = "69"
  }

}
