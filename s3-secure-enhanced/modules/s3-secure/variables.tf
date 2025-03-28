variable "bucket_name" {
  description = "Name of the main S3 bucket"
  type        = string
}

variable "logging_bucket" {
  description = "Name of the logging bucket"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the bucket"
  type        = map(string)
  default     = {}
}

