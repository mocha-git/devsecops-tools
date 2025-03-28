output "bucket_id" {
  description = "The ID of the secure S3 bucket"
  value       = aws_s3_bucket.secure.id
}

output "bucket_arn" {
  description = "The ARN of the secure S3 bucket"
  value       = aws_s3_bucket.secure.arn
}
