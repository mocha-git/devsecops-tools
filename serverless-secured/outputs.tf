output "lambda_arn" {
  description = "ARN de la Lambda déployée"
  value       = module.serverless_arch.lambda_arn
}

output "api_endpoint" {
  description = "Endpoint de l'API Gateway HTTP"
  value       = module.serverless_arch.api_endpoint
}

output "user_pool_id" {
  description = "ID du user pool Cognito"
  value       = module.serverless_arch.user_pool_id
}

