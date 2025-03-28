provider "aws" {
  region = var.region

  default_tags {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "Security Factory"
  }
}

resource "aws_kms_key" "s3_encryption_key" {
  description             = "KMS key for S3 bucket encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_s3_bucket_public_access_block" "secure" {
  bucket = module.secure_s3.bucket_id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle" {
  bucket = module.secure_s3.bucket_id

  rule {
    id     = "transition-to-infrequent-access"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 365
    }
  }
}
