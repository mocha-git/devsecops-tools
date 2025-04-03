########################################
# WAF v2 (régional) + Association
########################################
resource "aws_wafv2_web_acl" "this" {
  name        = "${local.prefix}-webacl"
  description = "WAF for ${local.prefix}"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSCommonRuleSet"
    priority = 1
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "commonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${local.prefix}-webacl"
    sampled_requests_enabled   = true
  }

  tags = {
    Name        = "${local.prefix}-webacl"
    Environment = "production"
  }
}

resource "aws_wafv2_web_acl_association" "this" {
  resource_arn = aws_apigatewayv2_stage.prod.arn
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}

