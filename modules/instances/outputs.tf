output "public_instance_ids" {
  description = "IDs of the public tier EC2 instances"
  value       = aws_instance.public[*].id
}

output "private_instance_ids" {
  description = "IDs of the private tier EC2 instances"
  value       = aws_instance.private[*].id
}

output "public_ec2_sg_id" {
  description = "Security group ID attached to public tier instances"
  value       = aws_security_group.public_ec2.id
}

output "private_ec2_sg_id" {
  description = "Security group ID attached to private tier instances"
  value       = aws_security_group.private_ec2.id
}
