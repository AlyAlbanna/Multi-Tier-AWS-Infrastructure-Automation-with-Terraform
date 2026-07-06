variable "project_name" {
  description = "Project name used for naming and tagging resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC the subnets belong to"
  type        = string
}

variable "igw_id" {
  description = "ID of the Internet Gateway (used in the public route table)"
  type        = string
}

variable "az_count" {
  description = "Number of Availability Zones to spread subnets across (used if availability_zones is not set explicitly)"
  type        = number
  default     = 2
}

variable "availability_zones" {
  description = "Explicit list of AZs to use. If empty, the first az_count available AZs in the region are used."
  type        = list(string)
  default     = []
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets, one per AZ"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets, one per AZ"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "tags" {
  description = "Common tags applied to all resources in this module"
  type        = map(string)
  default     = {}
}
