module "terratest_htme_vpc" {
  source   = "dwp/vpc/aws"
  version  = "3.0.23"
  vpc_name = "vpc-module-test"
  region   = "eu-west-1"

  vpc_cidr_block = "10.100.0.0/24"
}

resource "aws_security_group" "terratest_internet_proxy_endpoint" {
  name        = "terratest_proxy_vpc_endpoint"
  description = "Control access to the Internet Proxy VPC Endpoint"
  vpc_id      = module.terratest_htme_vpc.vpc.id
  tags        = local.common_tags
}

resource "aws_vpc_endpoint" "internet_proxy" {
  vpc_id              = module.terratest_htme_vpc.vpc.id
  service_name        = data.terraform_remote_state.internet_egress.outputs.internet_proxy_service.service_name
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.terratest_internet_proxy_endpoint.id]
  subnet_ids          = aws_subnet.terratest_vpc_endpoints.*.id
  private_dns_enabled = false
}

resource "aws_subnet" "htme" {
  count = length(data.aws_availability_zones.available.names)
  cidr_block = cidrsubnet(
    module.terratest_htme_vpc.vpc.cidr_block,
    9,
    count.index + 30,
  )
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = module.terratest_htme_vpc.vpc.id

  tags = merge(
    local.common_tags,
    {
      "application" = "terratest-htme"
      "Name"        = "terratest-htme-private"
    },
  )
}

resource "aws_subnet" "terratest_vpc_endpoints" {
  count = length(data.aws_availability_zones.available.names)
  # Place VPC endpoint subnets at the end of the VPC range to keep them out
  # of the way of everything else
  cidr_block = cidrsubnet(
    module.terratest_htme_vpc.vpc.cidr_block,
    9,
    count.index + 509,
  )
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = module.terratest_htme_vpc.vpc.id

  tags = merge(
    local.common_tags,
    {
      "Name" = "terratest-vpc-endpoints"
    },
  )
}

resource "aws_service_discovery_service" "htme_services" {
  name = "terratest-htme-pushgateway"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.htme_services.id

    dns_records {
      ttl  = 10
      type = "A"
    }
  }

  tags = merge(local.common_tags, { Name = "terratest_htme_services" })
}

resource "aws_service_discovery_private_dns_namespace" "htme_services" {
  name = "${local.environment}.htme.services.${jsondecode(data.aws_secretsmanager_secret_version.terraform_secrets.secret_binary)["dataworks_domain_name"]}"
  vpc  = module.terratest_htme_vpc.vpc.id
  tags = merge(local.common_tags, { Name = "terratest_htme_services" })
}
