output "ecs_sg_id" {
  value = aws_security_group.ecs_sg.id
}
output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}
output "vpc_endpoints_sg_id" {
  value = aws_security_group.vpc_endpoints_sg.id
}