resource "aws_route53_zone" "this" {
  name = var.domain_name
  tags = var.tags
}

data "aws_route53_zone" "main" {
  count = var.create_r53_zone && var.zone_id == null ? 0 : 1

  name         = "${var.domain_name}."
  private_zone = false
}