variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"  
}

variable "vpc_name" {
  type    = string
  default = "urlshort-prod-vpc"
}

variable "domain_name" {
  type    = string
  default = "ahmedumami.click"
}

variable "subject_alternative_names" {
  type    = list(string)
  default = ["www.ahmedumami.click"]
}

variable "azs" {
  type    = list(string)
  default = ["eu-west-2a", "eu-west-2b"]
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.1.11.0/24", "10.1.12.0/24"]
}

variable "allowed_ips" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "route53_zone_id" {
  type    = string
}

variable "container_name" {
  type = string
}

variable "container_image" {
  type = string
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "project" {
  type    = string
  default = "urlshort-prod"
}

variable "project_name" {
  type    = string
  default = "urlshort-prod"
}

variable "task_cpu" {
  type    = string
  default = "512"  
}

variable "task_memory" {
  type    = string
  default = "1024"  
}

variable "dynamodb_table_name" {
  type    = string
  default = "urlshortener-prod-table"
}

variable "dynamodb_billing_mode" {
  type    = string
  default = "PAY_PER_REQUEST"
}

variable "dynamodb_hash_key" {
  type    = string
  default = "id"
}

variable "dynamodb_attribute_name" {
  type    = string
  default = "id"
}

variable "dynamodb_attribute_type" {
  type        = string
  description = "Attribute type (S, N, B)"
  default     = "S"
}

variable "pitr_enabled" {
  type    = bool
  default = true
}

variable "dynamodb_ttl_attribute_name" {
  type    = string
  default = "ttl"
}

variable "dynamodb_ttl_enabled" {
  type    = bool
  default = true
}