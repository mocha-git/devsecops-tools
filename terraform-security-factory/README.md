# 🚀 Terraform Security Factory

Reusable Terraform modules with built-in security audits, automated testing, and full CI/CD pipeline.

## 🔧 Modules included

- `secure-s3`: Secure AWS S3 bucket module (encryption, versioning, no public access).

## 🧪 Testing & Security

- Automated tests with Terratest & tftest.hcl
- Security scanning: tfsec, Checkov, OPA (policy-as-code)

## 🚨 Usage Example

```hcl
module "secure_s3_example" {
  source      = "../../modules/secure-s3"
  bucket_name = var.bucket_name
}
