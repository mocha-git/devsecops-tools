########################################
# DynamoDB Table
########################################
resource "aws_dynamodb_table" "main" {
  name         = "${local.prefix}-table"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "PK"
  attribute {
    name = "PK"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }

  tags = {
    Name        = "${local.prefix}-table"
    Environment = "production"
  }
}

