variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  type    = string
  default = "urlshort-dev-vpc"
}

variable "azs" {
  type    = list(string)
  default = ["eu-west-2a", "eu-west-2b"]
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.11.0/24", "10.0.12.0/24"]
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
  default = "urlshortener "
}

variable "project_name" {
  type    = string
  default = "urlshortener"
}

variable "task_cpu" {
  type    = string
  default = "256"
}

variable "task_memory" {
  type    = string
  default = "512"
}

variable "dynamodb_table_name" {
  type    = string
  default = "urlshortener-dev-table"
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