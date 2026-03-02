variable "tag_name" {
  type = string
}
variable "dynamodb_table_name" {
  type        = string
}

variable "dynamodb_hash_key" {
  type        = string
}

variable "dynamodb_attribute_name" {
  type        = string
}

variable "dynamodb_attribute_type" {
  type        = string
}

variable "dynamodb_billing_mode" {
  type        = string
}

variable "dynamodb_ttl_attribute_name" {
  type        = string
}

variable "dynamodb_ttl_enabled" {
  type        = bool
}
variable "pitr_enabled" {
  type = bool
}
