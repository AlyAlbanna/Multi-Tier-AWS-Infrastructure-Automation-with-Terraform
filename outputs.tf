output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.subnets.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.subnets.private_subnet_ids
}

output "nat_gateway_ids" {
  description = "IDs of the NAT gateways (one per AZ)"
  value       = module.subnets.nat_gateway_ids
}

output "external_alb_dns_name" {
  description = "Public URL of the internet-facing ALB — this is the entry point for users"
  value       = module.load_balancers.external_alb_dns_name
}

output "internal_alb_dns_name" {
  description = "DNS name of the internal ALB (proxy) that fronts the private tier"
  value       = module.load_balancers.internal_alb_dns_name
}

output "public_instance_ids" {
  description = "EC2 instance IDs in the public tier"
  value       = module.instances.public_instance_ids
}

output "private_instance_ids" {
  description = "EC2 instance IDs in the private tier"
  value       = module.instances.private_instance_ids
}
