variable "project_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "cpu_threshold" {
  description = "CPU utilisation threshold for scaling/alarm"
  type        = number
  default     = 70
}

variable "memory_threshold" {
  type = number
  default = 80
}

variable "alert_email" {
  description = "email address for CloudWatch alerts"
  type        = string
}
variable "arn_suffix" {
  type = string
}