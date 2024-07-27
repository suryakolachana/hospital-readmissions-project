output "bucket_name" {
  value = google_storage_bucket.gcf_bucket.name
}

output "function_name" {
  value = google_cloudfunctions_function.function.name
}
