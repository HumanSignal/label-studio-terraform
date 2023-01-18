output "hostname" {
  value = data.kubernetes_service.nginx-ingress-service.status.0.load_balancer.0.ingress.0.hostname
}

output "ip" {
  value = data.kubernetes_service.nginx-ingress-service.status.0.load_balancer.0.ingress.0.ip
}
