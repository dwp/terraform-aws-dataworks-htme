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

resource "aws_security_group_rule" "dks_host_outbound_tanium_1" {
  type              = "egress"
  from_port         = var.tanium_port_1
  to_port           = var.tanium_port_1
  protocol          = "tcp"
  prefix_list_ids   = var.tanium_prefix
  security_group_id = aws_security_group.htme.id
}

resource "aws_security_group_rule" "dks_host_outbound_tanium_2" {
  type              = "egress"
  from_port         = var.tanium_port_2
  to_port           = var.tanium_port_2
  protocol          = "tcp"
  prefix_list_ids   = var.tanium_prefix
  security_group_id = aws_security_group.htme.id
}

resource "aws_security_group_rule" "dks_host_inbound_tanium_1" {
  type              = "ingress"
  from_port         = var.tanium_port_1
  to_port           = var.tanium_port_1
  protocol          = "tcp"
  prefix_list_ids   = var.tanium_prefix
  security_group_id = aws_security_group.htme.id
}

resource "aws_security_group_rule" "dks_host_inbound_tanium_2" {
  type              = "ingress"
  from_port         = var.tanium_port_2
  to_port           = var.tanium_port_2
  protocol          = "tcp"
  prefix_list_ids   = var.tanium_prefix
  security_group_id = aws_security_group.htme.id
}
