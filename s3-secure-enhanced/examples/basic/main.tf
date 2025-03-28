provider "aws" {
  region = "us-east-1"
}

module "s3_secure" {
  source         = "../../modules/s3-secure"
  bucket_name    = "my-secure-bucket-example"
  logging_bucket = "my-logging-bucket"
  tags = {
    Environment = "dev"
    Project     = "secure-s3"
  }
}