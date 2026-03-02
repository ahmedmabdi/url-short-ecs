variable "ecs_task_execution_role_name" {
  type = string
}

variable "ecs_task_role_name" {
  type = string
}
variable "aws_region" {
  default = "eu-west-2"

}
variable "dynamodb_table_arn" {
  type        = string
}
