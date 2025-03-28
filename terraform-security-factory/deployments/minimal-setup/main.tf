terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.37.0"
    }
  }

  backend "s3" {
    bucket       = "terraform-state-bucket"
    key          = "terraform-security-factory/state"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-east-1"
}

module "secure_s3" {
  source             = "../../modules/secure-s3"
  bucket_name        = var.bucket_name
  environment        = var.environment
  versioning_enabled = true

  encryption_settings = {
    sse_algorithm     = "aws:kms"
    kms_master_key_id = aws_kms_key.s3_encryption_key.arn
  }
}

output "bucket_id" {
  value = module.secure_s3_example.bucket_id
}

