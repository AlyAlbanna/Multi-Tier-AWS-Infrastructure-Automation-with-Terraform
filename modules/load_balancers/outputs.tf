output "external_alb_dns_name" {
  description = "DNS name of the internet-facing ALB"
  value       = aws_lb.external.dns_name
}

output "external_alb_sg_id" {
  description = "Security group ID of the external ALB"
  value       = aws_security_group.external_alb.id
}

output "public_target_group_arn" {
  description = "ARN of the target group behind the external ALB (public tier)"
  value       = aws_lb_target_group.public.arn
}

output "internal_alb_dns_name" {
  description = "DNS name of the internal ALB (proxy)"
  value       = aws_lb.internal.dns_name
}

output "internal_alb_sg_id" {
  description = "Security group ID of the internal ALB (proxy)"
  value       = aws_security_group.internal_alb.id
}

output "private_target_group_arn" {
  description = "ARN of the target group behind the internal ALB (private tier)"
  value       = aws_lb_target_group.private.arn
}
