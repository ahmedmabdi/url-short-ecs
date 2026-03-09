variable "alb_dns_name" {
  description = "DNS name of the ALB origin"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for CloudFront HTTPS"
  type        = string
}

variable "waf_arn" {
  description = "WAFv2 Web ACL ARN to attach to CloudFront"
  type        = string
}
variable "domain_name" {
  type    = string
  default = "ahmedumami.click"
}

variable "subject_alternative_names" {
  type    = list(string)
  default = ["www.ahmedumami.click"]
}

variable "route53_zone_id" {
  type    = string
  default = "Z103935430WUS287YMWJ6"
}
