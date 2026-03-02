variable "cluster_name" {
  type    = string
  default = "url-shortener"
}
variable "vpc_id" {
  type = string
}

variable "task_family" {
  type = string
}

variable "task_cpu" {
  type    = string
}

variable "task_memory" {
  type    = string
}

variable "task_role_arn" {
  type    = string
}

variable "container_name" {
  type = string
}

variable "container_image" {
  type = string
}

variable "container_port" {
  type = number
}

variable "service_name" {
  type = string
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "min_count" {
  type    = number
  default = 1
}

variable "max_count" {
  type    = number
  default = 3
}

variable "private_subnets" {
  type = list(string)
}

variable "target_group_arn" {
  type = string
}

variable "region" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "ecs_sg_id" {
  type = string
}

variable "project_name" {
  type = string
}

variable "dynamodb_table_name" {
  type = string
}
