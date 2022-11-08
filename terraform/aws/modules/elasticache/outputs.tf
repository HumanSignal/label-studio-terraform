output "host" {
  value = aws_elasticache_replication_group.elasticache.connection
}
output "port" {
  value = aws_elasticache_replication_group.elasticache.port
}
