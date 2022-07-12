# This file needs to be outside the module and at the provider level (internal compute)

resource "aws_subnet" "htme" {
  count = length(data.aws_availability_zones.available.names)
  cidr_block = cidrsubnet(
    module.internal_compute_vpc.vpc.cidr_block,
    9,
    count.index + 30,
  )
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = module.internal_compute_vpc.vpc.id

  tags = merge(
    var.common_tags,
    {
      "application" = "htme"
      "Name"        = "htme-private"
    },
  )
}

# Create a new route table for the compaction subnets
resource "aws_route_table" "htme" {
  vpc_id = module.internal_compute_vpc.vpc.id

  tags = merge(
    var.common_tags,
    {
      "application" = "htme"
    },
  )
}

resource "aws_route_table_association" "htme" {
  count          = length(data.aws_availability_zones.available.names)
  subnet_id      = element(aws_subnet.htme.*.id, count.index)
  route_table_id = aws_route_table.htme.id
}

resource "aws_route" "htme_dks" {
  count = length(
    data.terraform_remote_state.crypto.outputs.dks_subnet.cidr_blocks,
  )
  route_table_id = aws_route_table.htme.id
  destination_cidr_block = element(
    data.terraform_remote_state.crypto.outputs.dks_subnet.cidr_blocks,
    count.index,
  )
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.crypto.id
}

resource "aws_route" "dks_htme" {
  provider                  = aws.management-crypto
  count                     = length(aws_subnet.htme.*.cidr_block)
  route_table_id            = data.terraform_remote_state.crypto.outputs.dks_route_table.id
  destination_cidr_block    = element(aws_subnet.htme.*.cidr_block, count.index)
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.crypto.id
}