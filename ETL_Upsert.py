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

    # Define the SQL query for the upsert
    query = f'''
    WITH new_data AS (
        SELECT * FROM {table.reference.path}
    )
    UPDATE {table.reference.path}
    SET is_active = new_data.is_active, purchase_date = new_data.purchase_date
    FROM new_data
    WHERE {table.reference.path}.{unique_id} = new_data.{unique_id}

    INSERT INTO {table.reference.path}
    SELECT * FROM new_data
    WHERE NOT EXISTS (
        SELECT 1 FROM {table.reference.path}
        WHERE {table.reference.path}.{unique_id} = new_data.{unique_id}
    )
    '''

    # Execute the query
    query_job = client.query(query)
    query_job.result()
