resource "aws_security_group" "htme" {
  name        = "htme"
  description = "Control access to and from the hbase-to-mongo-exporter Hosts"
  vpc_id      = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      "application" = "htme"
    },
  )
}
