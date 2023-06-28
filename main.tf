provider "google" {
  project = "my-project-id"
  region  = "us-central1"
}

resource "google_storage_bucket" "data_bucket" {
  name     = "<your-bucket-name>"
  location = "US"
}

resource "google_sql_database_instance" "airflow_db" {
  name             = "<your-db-instance-name>"
  database_version = "POSTGRES_11"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        value           = "<ip-address>"
        name            = "<network-name>"
        expiration_time = "<expiration-date>"
      }
    }
  }
}

resource "google_sql_database" "airflow_metadata" {
  name       = "airflow_metadata"
  instance   = google_sql_database_instance.airflow_db.name
  collation  = "en_US.UTF8"
}

resource "google_compute_instance" "airflow" {
  name         = "<your-instance-name>"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    ssh-keys = "<user>:<public-key>"
  }
}
