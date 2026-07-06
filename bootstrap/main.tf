terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "remote_backend" {
  source = "../modules/remote_backend"

  state_bucket_name = var.state_bucket_name
  lock_table_name    = var.lock_table_name
  force_destroy      = false

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
