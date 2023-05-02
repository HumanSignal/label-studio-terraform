output "namespace" {
  value = kubernetes_namespace.namespace.metadata[0].name
}
