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

variable "alb_dns_name" {
  type = string
}

variable "alb_zone_id" {
  type = string
}

variable "zone_id" {
  type = string
}