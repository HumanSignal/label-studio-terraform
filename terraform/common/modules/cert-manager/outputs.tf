output "issuer_name" {
  value = var.selfsigned ? kubectl_manifest.selfsigned_cluster_issuer[0].name : kubectl_manifest.letsencrypt_cluster_issuer[0].name
}

output "namespace" {
  value = kubernetes_namespace.this.metadata[0].name
}

output "tls_secret_name" {
  value = yamldecode(kubectl_manifest.certificate.yaml_body).secretName
}
