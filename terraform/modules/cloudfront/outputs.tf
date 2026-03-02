output "cf_waf_arn" {
  value = aws_wafv2_web_acl.cf_waf.arn
  description = "WAF ARN attached to the ALB"
}