output "zone_name" {
  value = var.create_r53_zone ? aws_route53_zone.this[0].name : data.aws_route53_zone.this[0].name
}

output "zone_id" {
  value = var.create_r53_zone ? aws_route53_zone.this[0].id : data.aws_route53_zone.this[0].id
}
