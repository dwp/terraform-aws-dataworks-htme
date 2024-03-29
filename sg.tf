resource "aws_security_group" "htme" {
  name_prefix            = "htme"
  description            = "Control access to and from the hbase-to-mongo-exporter Hosts"
  revoke_rules_on_delete = true
  vpc_id                 = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.common_tags,
    {
      "application" = "htme"
    },
  )
}
