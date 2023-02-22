# DW-2991 AWS - Send Snapshots to Crown Epic - as part of this, increase log retention so we can look at trends over time.
# Once we are happy with trends and monitoring, change back to the standard 30 days from 180.
# Fits with log retention policy https://git.ucd.gpn.gov.uk/dip/aws-common-infrastructure/wiki/Audit-Logging#log-retention-policy
resource "aws_cloudwatch_log_group" "htme" {
  name              = local.cw_agent_log_group_name_htme
  retention_in_days = 180
  tags              = local.common_tags
}

resource "aws_cloudwatch_log_group" "acm_cert_retriever" {
  name              = local.cw_agent_log_group_name_acm
  retention_in_days = 180
  tags              = local.common_tags
}

resource "aws_cloudwatch_log_group" "application" {
  name              = local.cw_agent_log_group_name_application
  retention_in_days = 180
  tags              = local.common_tags
}

resource "aws_cloudwatch_log_group" "bootstrapping" {
  name              = local.cw_agent_log_group_name_boostrapping
  retention_in_days = 180
  tags              = local.common_tags
}

resource "aws_cloudwatch_log_group" "system" {
  name              = local.cw_agent_log_group_name_system
  retention_in_days = 180
  tags              = local.common_tags
}

resource "aws_cloudwatch_log_group" "uc_export_to_crown_controller" {
  name              = local.cw_uc_export_to_crown_controller
  retention_in_days = 180
  tags              = local.common_tags
}
