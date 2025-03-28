package terraform.security

import future.keywords.in

# Deny rules for AWS S3 bucket security
deny[msg] {
    resource := input.resource.aws_s3_bucket[_]
    not resource.versioning.enabled
    msg := "Bucket versioning must be enabled"
}

deny[msg] {
    resource := input.resource.aws_s3_bucket[_]
    not resource.server_side_encryption_configuration.rule[_].apply_server_side_encryption_by_default.sse_algorithm == "AES256"
    msg := "AES256 encryption must be enabled"
}

# Additional security checks
warn[msg] {
    resource := input.resource.aws_s3_bucket[_]
    not resource.logging.enabled
    msg := "Bucket logging is recommended"
}

# Check for required tags
deny[msg] {
    resource := input.resource.aws_s3_bucket[_]
    not resource.tags["Environment"] 
    msg := "Environment tag is required"
}

# Validate bucket naming convention
deny[msg] {
    resource := input.resource.aws_s3_bucket[_]
    not regex(`^[a-z0-9.-]+$`, resource.bucket)
    msg := "Bucket name must be lowercase, contain only letters, numbers, hyphens, and periods"
}
