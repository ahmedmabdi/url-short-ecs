output "alb_certificate_arn" {
  value = aws_acm_certificate.this.arn
}
output "certificate_validation_ref" {
  value = aws_acm_certificate_validation.this
}
output "cloudfront_certificate_arn" {
  value = aws_acm_certificate_validation.cf_cert_validation.certificate_arn
}