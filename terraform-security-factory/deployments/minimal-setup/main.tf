terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-3"
}

module "secure_s3_example" {
  source      = "../../modules/secure-s3"
  bucket_name = var.bucket_name
}

output "bucket_id" {
  value = module.secure_s3_example.bucket_id
}

