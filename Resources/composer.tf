resource "google_composer_environment" "my_environment" {
  project = "my_project"
  name    = "my_environment"
  
  config {
    node_config {
      machine_type = "n1-standard-1"
    }
  }
}
