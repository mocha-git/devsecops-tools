output "lambda_arn" {
  description = "ARN de la Lambda"
  value       = aws_lambda_function.this.arn
}

output "api_endpoint" {
  description = "Endpoint HTTP API"
  value       = "${aws_apigatewayv2_api.this.api_endpoint}/${aws_apigatewayv2_stage.prod.name}"
}

output "user_pool_id" {
  value       = aws_cognito_user_pool.this.id
  description = "ID du Cognito User Pool"
}

