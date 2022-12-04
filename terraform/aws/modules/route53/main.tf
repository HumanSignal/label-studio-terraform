resource "aws_route53_zone" "this" {
  count = var.create_r53_zone ? 1 : 0

  name = var.domain_name
  tags = var.tags
}

data "aws_route53_zone" "this" {
  count = var.create_r53_zone ? 0 : 1

  name         = var.domain_name
}

data "aws_lb" "this" {
  name = "nb-ls"
}

resource "aws_route53_record" "this" {
  name    = var.record_name
  zone_id = var.create_r53_zone? aws_route53_zone.this[0].zone_id : data.aws_route53_zone.this[0].zone_id
  type    = "A"

  alias {
    evaluate_target_health = false
    name                   = data.aws_lb.this.dns_name
    zone_id                = data.aws_lb.this.zone_id
  }
}
