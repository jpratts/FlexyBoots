import csv
import yaml
from google.cloud import bigquery

def create_upsert_script(schema_file, unique_id, table_name):

    # Load the schema from the YAML file
    with open(schema_file, 'r') as stream:
        schema_data = yaml.safe_load(stream)

    # Convert the schema data to a list of BigQuery SchemaField objects
    schema = [bigquery.SchemaField(field['name'], field['type'], mode=field.get('mode', 'NULLABLE')) for field in schema_data]

    # Create a BigQuery client
    client = bigquery.Client()

    # Define the dataset and table name
    dataset_id = 'my_dataset'
    table_id = table_name

    # Create the table if it doesn't already exist
    table = bigquery.Table(f"{client.project}.{dataset_id}.{table_id}", schema=schema)
    table = client.create_table(table)

    # Define the name of the CSV file in the Cloud Storage bucket
    csv_file = 'gs://my_bucket/subscribers.csv'

    # Load the data from the CSV file into the table
    job_config = bigquery.LoadJobConfig(
        source_format=bigquery.SourceFormat.CSV,
        skip_leading_rows=1,
        write_disposition='WRITE_APPEND'
    )
    load_job = client.load_table_from_uri(csv_file, table.reference, job_config=job_config)
    load_job.result()
    
    query_result = load_job.result()
    rows_updated = load_job.rows_updated
    rows_deleted = load_job.rows_deleted
    is_success   = query_job.state
    
    # Get the current time
    execution_time = datetime.datetime.now()

    # Insert a record into the ExecutionHistory table
    execution_history_table_id = 'ExecutionHistory'
    execution_history_table = bigquery.Table(f"{client.project}.{dataset_id}.{execution_history_table_id}")
    execution_history_schema = [
        bigquery.SchemaField('execution_time', 'TIMESTAMP', mode='REQUIRED'),
        bigquery.SchemaField('table_name', 'STRING', mode='REQUIRED'),
        bigquery.SchemaField('rows_updated', 'INTEGER', mode='REQUIRED'),
        bigquery.SchemaField('rows_deleted', 'INTEGER', mode='REQUIRED'),
        bigquery.SchemaField('is_success', 'STRING', mode='REQUIRED')
    ]
    
    record_job = client.insert_rows(execution_history_table, [(execution_time, table_name, rows_updated, rows_deleted, is_success)])
    record_job.result()
