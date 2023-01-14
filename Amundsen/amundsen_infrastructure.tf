resource "google_sql_database_instance" "amundsen_instance" {
  name = "amundsen-instance"
  region = "us-central1"
  settings {
    tier = "db-f1-micro"
    database_version = "POSTGRES_11"
  }
  root_password = "my-password"
}

resource "google_container_cluster" "amundsen_cluster" {
  name = "amundsen-cluster"
  zone = "us-central1-a"
  initial_node_count = 3
}

resource "google_storage_bucket" "amundsen_bucket" {
  name = "amundsen-bucket"
}

resource "google_compute_http_health_check" "amundsen_health_check" {
  name = "amundsen-health-check"
  request_path = "/health"
}

resource "google_compute_target_http_proxy" "amundsen_proxy" {
  name = "amundsen-proxy"
  url_map = google_compute_url_map.amundsen_url_map.self_link
}

resource "google_compute_url_map" "amundsen_url_map" {
  name = "amundsen-url-map"
  default_service = google_compute_backend_service.amundsen_service.self_link
}

resource "google_compute_backend_service" "amundsen_service" {
  name = "amundsen-service"
  health_checks = [google_compute_http_health_check.amundsen_health_check.self_link]
}

resource "google_compute_forwarding_rule" "amundsen_forwarding_rule" {
  name = "amundsen-forwarding-rule"
  port_range = "80"
  target = google_compute_target_http_proxy.amundsen_proxy.self_link
}

resource "google_container_deployment" "amundsen_deployment" {
  name = "amundsen"
  namespace = "amundsen"
  image = "gcr.io/amundsen-io/amundsen:latest"

  env {
    name = "AMUNDSEN_DB_CONNECTION"
    value = "postgresql://user:password@amundsen-instance:5432/postgres"
  }

  env {
    name = "AMUNDSEN_FRONTEND_BUCKET"
    value = google_storage_bucket.amundsen_bucket.name
  }
}
