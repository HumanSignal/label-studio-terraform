resource "aws_route53_zone" "r53_zone" {
  count = var.create_r53_zone ? 1 : 0

  name = var.zone_name
  tags = var.tags
}

data "aws_route53_zone" "r53_zone" {
  count = var.create_r53_zone ? 0 : 1

  name = var.zone_name
}
