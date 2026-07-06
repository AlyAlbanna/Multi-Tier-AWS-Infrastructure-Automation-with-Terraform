locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
  tags         = local.common_tags
}

module "subnets" {
  source = "./modules/subnets"

  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  igw_id                = module.vpc.igw_id
  az_count              = var.az_count
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  tags                  = local.common_tags
}

module "load_balancers" {
  source = "./modules/load_balancers"

  project_name        = var.project_name
  vpc_id              = module.vpc.vpc_id
  vpc_cidr            = var.vpc_cidr
  public_subnet_ids   = module.subnets.public_subnet_ids
  private_subnet_ids  = module.subnets.private_subnet_ids
  tags                = local.common_tags
}

module "instances" {
  source = "./modules/instances"

  project_name        = var.project_name
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.subnets.public_subnet_ids
  private_subnet_ids  = module.subnets.private_subnet_ids
  external_alb_sg_id  = module.load_balancers.external_alb_sg_id
  internal_alb_sg_id  = module.load_balancers.internal_alb_sg_id
  instance_type       = var.instance_type
  ami_id              = var.ami_id
  key_name            = var.key_name
  tags                = local.common_tags
}

resource "aws_lb_target_group_attachment" "public" {
  count            = length(module.instances.public_instance_ids)
  target_group_arn = module.load_balancers.public_target_group_arn
  target_id        = module.instances.public_instance_ids[count.index]
  port             = 80
}

resource "aws_lb_target_group_attachment" "private" {
  count            = length(module.instances.private_instance_ids)
  target_group_arn = module.load_balancers.private_target_group_arn
  target_id        = module.instances.private_instance_ids[count.index]
  port             = 80
}
