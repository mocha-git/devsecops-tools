output "bucket_arn" {
  value       = module.secure_s3.bucket_arn
  description = "The ARN of the created S3 bucket"
}

output "kms_key_id" {
  value       = aws_kms_key.s3_encryption_key.key_id
  description = "The ID of the KMS key used for S3 encryption"
}
