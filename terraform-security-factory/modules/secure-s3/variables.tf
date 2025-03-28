variable "region" {
  type        = string
  description = "AWS region for deployment"
  default     = "eu-west-3"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
  default     = "production"
}

variable "bucket_name" {
  type        = string
  description = "Name of the secure S3 bucket"
}
