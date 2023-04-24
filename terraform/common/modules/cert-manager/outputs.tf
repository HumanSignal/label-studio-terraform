output "issuer_name" {
  value = kubectl_manifest.letsencrypt_cluster_issuer.name
}

output "namespace" {
  value = kubernetes_namespace.this.metadata[0].name
}

output "tls_secret_name" {
  value = var.tls_secret_name
}
