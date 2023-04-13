# Create Google Service Account
resource "google_service_account" "service_account" {
  account_id   = format("%s-sa", var.name)
  display_name = "GKE Security Service Account"
  project      = var.project_id
}

resource "google_service_account_key" "service_account_key" {
  service_account_id = format(google_service_account.service_account.name)
}

# Add the service account to the project
resource "google_project_iam_member" "roles" {
  for_each = toset(var.service_account_iam_roles)
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.service_account.email}"
}

# Allows management of single API service for an existing Google Cloud Platform project.
resource "google_project_service" "project_services" {
  count                      = length(var.project_services)
  project                    = var.project_id
  service                    = element(var.project_services, count.index)
  disable_on_destroy         = false
  disable_dependent_services = false
}
