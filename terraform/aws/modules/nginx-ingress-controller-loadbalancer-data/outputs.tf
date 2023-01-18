output "host" {
  value = data.aws_lb.this.dns_name
}

output "load_balancer_dns_name" {
  value = data.aws_lb.this.dns_name
}

output "load_balancer_zone_id" {
  value = data.aws_lb.this.zone_id
}
