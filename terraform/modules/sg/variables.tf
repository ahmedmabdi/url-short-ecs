variable "vpc_id" {
  type = string
}
variable "project_name" {
  type    = string
  default = "ecs-umami"
}

variable "allowed_ips" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
