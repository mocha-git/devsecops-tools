package terraform.security

deny[msg] {
  resource := input.resource.aws_s3_bucket[_]
  not resource.versioning.enabled
  msg = "Bucket versioning doit être activé."
}

deny[msg] {
  resource := input.resource.aws_s3_bucket[_]
  not resource.encryption.rule[_].apply_server_side_encryption_by_default.sse_algorithm == "AES256"
  msg = "Le chiffrement AES256 doit être activé."
}

