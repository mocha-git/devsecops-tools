########################################
# Cognito User Pool
########################################
resource "aws_cognito_user_pool" "this" {
  name = "${local.prefix}-userpool"

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
    require_uppercase = true
  }

  mfa_configuration = "OFF" # Pour renforcer, mettre "ON" ou "OPTIONAL"

  tags = {
    Name        = "${local.prefix}-userpool"
    Environment = "production"
  }
}

resource "aws_cognito_user_pool_domain" "this" {
  depends_on = [aws_cognito_user_pool.this]

  domain       = var.cognito_domain_prefix != "" ? var.cognito_domain_prefix : "${local.prefix}-${random_id.suffix.hex}"
  user_pool_id = aws_cognito_user_pool.this.id
}

resource "aws_cognito_user_pool_client" "this" {
  name         = "${local.prefix}-userpoolclient"
  user_pool_id = aws_cognito_user_pool.this.id

  allowed_oauth_flows_user_pool_client = true
  generate_secret                      = false

  allowed_oauth_flows = ["code", "implicit"]
  allowed_oauth_scopes = [
    "phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"
  ]
  supported_identity_providers = ["COGNITO"]

  callback_urls = ["https://example.com/callback"]
  logout_urls   = ["https://example.com/logout"]
}

