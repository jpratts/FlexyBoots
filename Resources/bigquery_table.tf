resource "google_bigquery_table" "subscribers_table" {
  dataset_id = "my_dataset"
  table_id   = "subscribers"

  schema = <<SCHEMA
[
  {
    "name": "id",
    "type": "INTEGER",
    "mode": "REQUIRED"
  },
  {
    "name": "is_active",
    "type": "BOOLEAN",
    "mode": "REQUIRED"
  },
  {
    "name": "purchase_date",
    "type": "DATE",
    "mode": "REQUIRED"
  }
]
SCHEMA
}

resource "google_bigquery_table" "execution_history_table" {
  dataset_id = "my_dataset"
  table_id   = "execution_history"

  schema = <<SCHEMA
[
  {
    "name": "execution_time",
    "type": "TIMESTAMP",
    "mode": "REQUIRED"
  },
  {
    "name": "table_name",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "rows_updated",
    "type": "INTEGER",
    "mode": "REQUIRED"
  },
  {
    "name": "rows_deleted",
    "type": "INTEGER",
    "mode": "REQUIRED"
  },
  {
    "name": "success",
    "type": "BOOLEAN",
    "mode": "REQUIRED"
  }
]
SCHEMA
}
