provider "google" {
  project = var.project_id
  region  = var.region
}

locals {
  ingest-timestamp = formatdate("YYMMDDhhmmss", timestamp())
  ingest_root_dir  = abspath("../ingest")
}

#compress source code
data "archive_file" "ingest-source" {
  type       =  "zip"
  source_dir =  local.ingest_root_dir
  output_path = "/tmp/ingest-${local.ingest-timestamp}.zip"
}

resource "google_storage_bucket" "gcf_bucket" {
  name          = var.bucket_name
  location      = var.region
  force_destroy = true
}

resource "google_storage_bucket_object" "ingest_zip" {
  name   = "${var.function_name}.zip#${data.archive_file.ingest-source.output_md5}"
  bucket = google_storage_bucket.gcf_bucket.name
  source = data.archive_file.ingest-source.output_path
}

#Cloud function resource creation
resource "google_cloudfunctions_function" "function" {
  name        = var.function_name
  description = "Cloud Function to ingest data from GCS"
  runtime     = var.runtime
  region      = var.region
  source_archive_bucket = google_storage_bucket.gcf_bucket.name
  source_archive_object = google_storage_bucket_object.ingest_zip.name
  entry_point = var.entry_point
  timeout     = var.timeout
  available_memory_mb = var.memory_mb

  event_trigger {
    event_type = "google.storage.object.finalize"
    resource   = google_storage_bucket.gcf_bucket.name
  }

  environment_variables = {
    GCP_PROJECT = var.project_id
  }
}