resource "google_project_iam_member" "data_engineer" {
  role   = "roles/bigquery.dataEditor"
  member = "user:data_engineer@example.com"
}

resource "google_project_iam_member" "data_scientist" {
  role   = "roles/bigquery.dataViewer"
  member = "user:data_scientist@example.com"
}
