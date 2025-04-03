# tftest.hcl
#
# Sample Terragrunt configuration pointing to our main Terraform module.
# Adjust paths and values as needed.

terraform {
  source = "../"  # Points to the main Terraform files in the parent folder
}

inputs = {
  project_name           = "test-project"
  aws_region             = "us-west-2"
  cognito_domain_prefix  = "test-domain-prefix"
}

