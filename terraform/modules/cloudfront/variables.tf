variable "alb_dns_name" {
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
}
variable "acm_certificate_arn" {
  type = string
}