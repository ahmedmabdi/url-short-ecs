variable "cluster_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "prod_target_group_name" {
  type = string
}

variable "test_target_group_name" {  
    type = string
}

variable "alb_https_listener_arn" {
  type = list(string)  
}
variable "env" {
  type = string
}
variable "alb_test_listener_arn" {
  type = list(string)
}