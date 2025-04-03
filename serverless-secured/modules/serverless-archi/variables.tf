variable "aws_region" {
  type        = string
  description = "Région AWS où déployer"
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Nom du projet (préfixe pour ressources)"
  default     = "secure-serverless"
}

variable "cognito_domain_prefix" {
  type        = string
  description = "Préfixe du domaine Cognito (doit être globalement unique)"
  default     = ""
}

