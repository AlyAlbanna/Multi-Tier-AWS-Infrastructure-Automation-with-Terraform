variable "project_name" {
  description = "Project name used for naming and tagging resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC, used to scope the internal ALB security group"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the internet-facing ALB"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the internal ALB (proxy)"
  type        = list(string)
}

variable "tags" {
  description = "Common tags applied to all resources in this module"
  type        = map(string)
  default     = {}
}
