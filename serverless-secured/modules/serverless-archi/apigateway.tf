########################################
# API Gateway v2 (HTTP API)
########################################

resource "aws_apigatewayv2_api" "this" {
  name          = "${local.prefix}-http-api"
  protocol_type = "HTTP"

  tags = {
    Name        = "${local.prefix}-http-api"
    Environment = "production"
  }
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.this.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.this.arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_authorizer" "cognito" {
  name            = "${local.prefix}-cognito-authorizer"
  api_id          = aws_apigatewayv2_api.this.id
  authorizer_type = "JWT"
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    issuer   = "https://${aws_cognito_user_pool_domain.this.domain}.auth.${var.aws_region}.amazoncognito.com"
    audience = [aws_cognito_user_pool_client.this.id]
  }
}

resource "aws_apigatewayv2_route" "hello_route" {
  api_id             = aws_apigatewayv2_api.this.id
  route_key          = "GET /hello"
  target             = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito.id
  authorization_type = "JWT"
}

resource "aws_apigatewayv2_stage" "prod" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "prod"
  auto_deploy = true

  tags = {
    Name        = "${local.prefix}-stage"
    Environment = "production"
  }
}

resource "aws_lambda_permission" "apigw_invoke" {
  statement_id  = "AllowAPIGWInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.this.execution_arn}/*"
}

