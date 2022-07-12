resource "aws_security_group" "htme" {
  name        = "htme"
  description = "Control access to and from the hbase-to-mongo-exporter Hosts"
  vpc_id      = module.internal_compute_vpc.vpc.id

  tags = merge(
    var.common_tags,
    {
      "application" = "htme"
    },
  )
}

resource "aws_security_group_rule" "htme_egress_internet_proxy" {
  description              = "HTME Host to Internet Proxy (for ACM-PCA)"
  type                     = "egress"
  source_security_group_id = aws_security_group.internet_proxy_endpoint.id
  protocol                 = "tcp"
  from_port                = 3128
  to_port                  = 3128
  security_group_id        = aws_security_group.htme.id
}

resource "aws_security_group_rule" "htme_ingress_internet_proxy" {
  description              = "Allow proxy access from HTME"
  type                     = "ingress"
  from_port                = 3128
  to_port                  = 3128
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.htme.id
  security_group_id        = aws_security_group.internet_proxy_endpoint.id
}

resource "aws_security_group_rule" "htme_egress_hbase_zookeeper" {
  description              = "Allow outbound requests to HBase zookeeper"
  type                     = "egress"
  from_port                = 2181
  to_port                  = 2181
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.emr_hbase_common.id
  security_group_id        = aws_security_group.htme.id
}

resource "aws_security_group_rule" "htme_egress_hbase_master" {
  description              = "Allow outbound requests to HBase master"
  type                     = "egress"
  from_port                = 16000
  to_port                  = 16000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.emr_hbase_common.id
  security_group_id        = aws_security_group.htme.id
}

resource "aws_security_group_rule" "htme_egress_hbase_regionserver" {
  description              = "Allow outbound requests to HBase RegionServer"
  type                     = "egress"
  from_port                = 16020
  to_port                  = 16020
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.emr_hbase_common.id
  security_group_id        = aws_security_group.htme.id
}

resource "aws_security_group_rule" "htme_egress_hbase_regionserver_info" {
  description              = "Allow outbound requests to HBase RegionServer Info"
  type                     = "egress"
  from_port                = 16030
  to_port                  = 16030
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.emr_hbase_common.id
  security_group_id        = aws_security_group.htme.id
}

resource "aws_security_group_rule" "htme_egress_dks" {
  description       = "Allow outbound requests to DKS"
  type              = "egress"
  from_port         = 8443
  to_port           = 8443
  protocol          = "tcp"
  cidr_blocks       = data.terraform_remote_state.crypto.outputs.dks_subnet.cidr_blocks
  security_group_id = aws_security_group.htme.id
}

resource "aws_security_group_rule" "htme_egress_s3" {
  description       = "Allow HTME to reach S3"
  type              = "egress"
  prefix_list_ids   = [module.internal_compute_vpc.prefix_list_ids.s3]
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  security_group_id = aws_security_group.htme.id
}

resource "aws_security_group_rule" "htme_egress_s3_http" {
  type      = "egress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  prefix_list_ids   = [module.internal_compute_vpc.prefix_list_ids.s3]
  security_group_id = aws_security_group.htme.id
}

resource "aws_security_group_rule" "htme_egress_dynamodb" {
  description       = "Allow HTME to reach DynamoDB"
  type              = "egress"
  prefix_list_ids   = [module.internal_compute_vpc.prefix_list_ids.dynamodb]
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  security_group_id = aws_security_group.htme.id
}

# DKS security group rule
resource "aws_security_group_rule" "htme_ingress_to_dks" {
  provider    = aws.management-crypto
  description = "Allow inbound requests to DKS from HTME"
  type        = "ingress"
  protocol    = "tcp"
  from_port   = 8443
  to_port     = 8443

  cidr_blocks = var.subnet_cidrs

  security_group_id = data.terraform_remote_state.crypto.outputs.dks_sg_id[var.environment]
}