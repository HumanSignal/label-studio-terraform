# Output variable for the service account email.
output "service_account" {
  description = "Service Account Email-id"
  value       = google_service_account.service_account.email
}

# Output variable for the service account key.
output "service_account_key" {
  description = "The service Account Key to configure Medusa backups to use GCS bucket"
  value       = base64decode(google_service_account_key.service_account_key.private_key)
  sensitive   = true
}
