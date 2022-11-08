output "host" {
  value = aws_db_instance.postgresql.address
}
output "port" {
  value = aws_db_instance.postgresql.port
}
output "database" {
  value = var.database
}
output "username" {
  value = var.username
}
output "password" {
  value = var.password
}
