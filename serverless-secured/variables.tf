variable "aws_region" {
  type        = string
  description = "Région AWS où déployer"
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Nom du projet"
  default     = "secure-serverless"
}

