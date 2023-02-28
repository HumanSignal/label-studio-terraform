resource "google_sql_database_instance" "instance" {
  name             = var.name
  region           = var.region
  database_version = "POSTGRES_14"

  deletion_protection = var.deletion_protection

  settings {
    tier = var.machine_type
  }
}

resource "google_sql_user" "user" {
  name     = var.name
  instance = google_sql_database_instance.instance.name
  password = var.password
}

resource "google_sql_database" "database" {
  name     = var.database
  instance = google_sql_database_instance.instance.name
}
