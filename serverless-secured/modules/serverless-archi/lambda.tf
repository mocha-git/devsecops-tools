########################################
# Lambda function + packaging
########################################

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda/app.zip"
}

resource "aws_iam_role" "lambda_exec" {
  name = "${local.prefix}-lambda-exec-role-${random_id.suffix.hex}"

  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json

  tags = {
    Name        = "${local.prefix}-lambda-exec-role"
    Environment = "production"
  }
}

data "aws_iam_policy_document" "lambda_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_inline" {
  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:UpdateItem"]
    resources = [aws_dynamodb_table.main.arn]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject", "s3:GetObject"]
    resources = ["${aws_s3_bucket.logs.arn}/*"]
  }
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "${local.prefix}-lambda-policy"
  role = aws_iam_role.lambda_exec.id

  policy = data.aws_iam_policy_document.lambda_inline.json
}

resource "aws_lambda_function" "this" {
  function_name = "${local.prefix}-lambda"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.9"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.main.name
    }
  }

  # Activer X-Ray
  tracing_config {
    mode = "Active"
  }

  tags = {
    Name        = "${local.prefix}-lambda"
    Environment = "production"
  }
}

