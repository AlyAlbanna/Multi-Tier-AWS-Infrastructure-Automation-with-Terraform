variable "project_name" {
  description = "Project name used for naming and tagging resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs, one instance will be launched per subnet"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs, one instance will be launched per subnet"
  type        = list(string)
}

variable "external_alb_sg_id" {
  description = "Security group ID of the external (internet-facing) ALB, allowed to reach the public tier"
  type        = string
}

variable "internal_alb_sg_id" {
  description = "Security group ID of the internal ALB (proxy), allowed to reach the private tier"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for all instances"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID to use. If left empty, the latest Amazon Linux 2023 AMI is looked up automatically."
  type        = string
  default     = ""
}

variable "key_name" {
  description = "EC2 key pair name for SSH access (optional)"
  type        = string
  default     = ""
}

variable "public_user_data" {
  description = "User data script for public tier instances"
  type        = string
  default     = <<-EOF
    #!/bin/bash
    dnf install -y httpd
    systemctl enable httpd
    systemctl start httpd
    echo "<h1>Public tier - $(hostname -f)</h1>" > /var/www/html/index.html
  EOF
}

variable "private_user_data" {
  description = "User data script for private tier instances"
  type        = string
  default     = <<-EOF
    #!/bin/bash
    dnf install -y httpd
    systemctl enable httpd
    systemctl start httpd
    echo "<h1>Private tier - $(hostname -f)</h1>" > /var/www/html/index.html
  EOF
}

variable "tags" {
  description = "Common tags applied to all resources in this module"
  type        = map(string)
  default     = {}
}
