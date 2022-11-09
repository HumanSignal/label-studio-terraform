output "host" {
  value = aws_elasticache_cluster.elasticache.cache_nodes[0].address
}
output "port" {
  value = aws_elasticache_cluster.elasticache.port
}
output "password" {
  value = ""
}
