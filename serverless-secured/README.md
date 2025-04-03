### **Serverless Secure Architecture with Terraform**

This project deploys a secure, serverless architecture on AWS using Terraform. It includes:

- **AWS Lambda** (Python)
- **Amazon API Gateway v2 (HTTP API)**
- **Amazon Cognito** (User Authentication via JWT)
- **Amazon DynamoDB** (NoSQL database with encryption at rest)
- **Amazon S3** (Logs storage, encrypted, versioning enabled)
- **AWS WAF v2** (Regional protection for the API)
- **IAM Roles and Policies** (Following least privilege principles)

---

## **Requirements**

- **Terraform** `>= 1.2.0`
- **AWS CLI** configured with appropriate credentials
- **Python 3.9** (for Lambda functions)
- **AWS Provider for Terraform** `>= 4.0`

---

## **Installation**

1. Clone this repository:

```bash
git clone <repo_url>
cd <project_directory>

2. Initialize Terraform:

terraform init

3. Preview the resources to be created:

terraform plan

4. Deploy the resources:

terraform apply
(confirm with yes if everything's good with you)

Usage
The API is protected by Cognito JWT authentication. To make requests, you need to:

Create a user in the Cognito User Pool.

Authenticate and retrieve a valid JWT token.

Send requests to the API Gateway using the token:

GET https://<API_ID>.execute-api.<region>.amazonaws.com/prod/hello?name=Alice
Authorization: Bearer <Your_JWT_Token>

Cleanup
To destroy all resources created:

terraform destroy
