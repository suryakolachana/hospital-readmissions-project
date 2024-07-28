project_id    = "named-vine-254515" # Replace with your own GCP Project ID
region        = "us-east4" # Replace with your own GCP default region
bucket_name   = "data-sci-prod-raw-zone" #Replace with your own unique bucket name
function_name = "file-ingest" #Replace with your own name
entry_point   = "ingest"
timeout       = 540 # This is max time limit for the cloud function to process the files.
