output "alb_arn" {
  value = aws_lb.this.arn
}

output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "alb_zone_id" {
  value = aws_lb.this.zone_id
}

output "target_group_arn" {
  value       = aws_lb_target_group.this.arn
}
output "alb_arn_suffix" {
  value       = aws_lb.this.arn_suffix
}

output "prod_target_group_arn" {
  value = aws_lb_target_group.prod.arn
}

output "test_target_group_arn" {
  value = aws_lb_target_group.test.arn
}

output "https_listener_arn" {
  value = aws_lb_listener.https.arn
}
output "prod_target_group_name" {
  value = aws_lb_target_group.prod.name
}

output "test_target_group_name" {
  value = aws_lb_target_group.test.name
}