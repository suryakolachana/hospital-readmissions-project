from google.cloud import bigquery
from google.cloud import storage
import logging
import json
import os

logging.basicConfig(level=logging.INFO)

def load_schema(schema_file):
    """Load schema from a JSON file."""
    with open(schema_file, 'r') as f:
        schema_list = json.load(f)
        schema = [bigquery.SchemaField(name=field['name'], field_type=field['type']) for field in schema_list]
        return schema

def ingest(event, context):
    """Triggered by a change to a Cloud Storage bucket.
    Args:
         event (dict): Event payload.
         context (google.cloud.functions.Context): Metadata for the event.
    """
    # Initialize BigQuery Client
    client = bigquery.Client()

    try:
        logging.info(f"Event: {event}")
        # Get the file from the event
        bucket_name = event['bucket']
        file_name = event['name']

        logging.info(f"Bucket: {bucket_name}, File: {file_name}")
        
        destination_uri = f"gs://{bucket_name}/{file_name}"
        staging_dataset_id = 'raw_data'

        # Create a Raw table by splitting the file name.
        staging_table_id = 'us' + '_' + '_'.join(file_name.split('_')[:2]).lower()
        
        logging.info(f"Destination URI: {destination_uri}")
        logging.info(f"Project: {client.project}")
        logging.info(f"Staging Table: {client.project}.{staging_dataset_id}.{staging_table_id}")

        transformed_dataset_id = 'processed_data'
        transformed_table_id = f"{staging_table_id}_partitioned"

        # Load schema from the schema.jsob file
        schema_file = os.path.join(os.path.dirname(__file__), 'schema.json')
        schema = load_schema(schema_file)
        
        # Load data into BigQuery using the job load API
        job_config = bigquery.LoadJobConfig(
            source_format=bigquery.SourceFormat.CSV,
            skip_leading_rows=1,  # Skip header row
            autodetect=False,  # Use the specified schema to overcome data type issues with autoschemadetect
            schema=schema,
            write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,  # Truncate for every load
            
        )

        logging.info(f"Job Config: {job_config}")

        load_job = client.load_table_from_uri(
            destination_uri,
            f"{client.project}.{staging_dataset_id}.{staging_table_id}",
            job_config=job_config
        )  # Make an API request.
        
        logging.info(f"Starting job {load_job.job_id}")

        load_job.result()  # Wait for the job to complete.

        logging.info(f"Job finished. Loaded {load_job.output_rows} rows into {staging_dataset_id}:{staging_table_id}.")

        # Read the SQL from the file
        with open("src/transformation.sql") as file:
            transformation_query = file.read()

        # Perform transformation and load into partitioned table
        transformation_query = transformation_query.format(project_id=client.project,
                                                           staging_dataset=staging_dataset_id,
                                                           staging_table=staging_table_id,
                                                           transformed_dataset=transformed_dataset_id,
                                                           transformed_table=transformed_table_id)
        query_job = client.query(transformation_query)
        query_job.result()  # Wait for the query to complete

        logging.info(f"Transformation job completed.")
    except Exception as e:
        logging.error(f"Error in Ingest process: {str(e)}")
        raise

