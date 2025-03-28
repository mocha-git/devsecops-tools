# s3-secure

A reusable Terraform module to create a secure S3 bucket with:

- Private access (block all public access)
- Server-side encryption (SSE-S3)
- Versioning enabled
- Logging to another bucket

## Usage

```hcl
module "s3_secure" {
  source         = "../../modules/s3-secure"
  bucket_name    = "my-secure-bucket"
  logging_bucket = "my-log-bucket"
  tags = {
    Environment = "dev"
    Project     = "secure-s3"
  }
}
```

## Requirements

- AWS CLI configured
- Terraform >= 1.0
- Go >= 1.20 (for tests)
- tfsec, tflint (for static analysis)