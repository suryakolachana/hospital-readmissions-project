variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "region" {
  description = "The region to deploy resources"
  type        = string
  default     = "us-east4"
}

variable "bucket_name" {
  description = "The name of the GCS bucket to create"
  type        = string
}

variable "function_name" {
  description = "The name of the Cloud Function"
  type        = string
}

variable "runtime" {
  description = "The runtime of the Cloud Function"
  type        = string
  default     = "python310"
}

variable "entry_point" {
  description = "The entry point function for the Cloud Function"
  type        = string
}

variable "timeout" {
  description = "The timeout for the Cloud Function"
  type        = string
  default     = 540
}

variable "memory_mb" {
  description = "The amount of memory to allocate to the Cloud Function"
  type        = number
  default     = 512
}
