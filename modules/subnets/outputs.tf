output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "availability_zones" {
  description = "AZs used for the subnets"
  value       = local.azs
}

output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways (one per AZ)"
  value       = aws_nat_gateway.this[*].id
}

output "public_route_table_id" {
  description = "ID of the shared public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "IDs of the private route tables (one per AZ)"
  value       = aws_route_table.private[*].id
}
