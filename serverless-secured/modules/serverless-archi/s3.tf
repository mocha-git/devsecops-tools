########################################
# S3 Bucket pour logs / artifacts
########################################
resource "aws_s3_bucket" "logs" {
  bucket = "${local.prefix}-logs-${random_id.suffix.hex}"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = "${local.prefix}-logs"
    Environment = "production"
  }
}

# Bloquer l'accès public
resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

