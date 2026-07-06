
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  ami_id = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux.id
}

resource "aws_security_group" "public_ec2" {
  name        = "${var.project_name}-public-ec2-sg"
  description = "Allow HTTP from the external ALB"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from external ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.external_alb_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-public-ec2-sg"
  })
}

resource "aws_security_group" "private_ec2" {
  name        = "${var.project_name}-private-ec2-sg"
  description = "Allow HTTP from the internal ALB (proxy) and public tier"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from internal ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.internal_alb_sg_id]
  }

  ingress {
    description     = "HTTP from public tier EC2 instances"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.public_ec2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-private-ec2-sg"
  })
}

resource "aws_instance" "public" {
  count                  = length(var.public_subnet_ids)
  ami                    = local.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_ids[count.index]
  vpc_security_group_ids = [aws_security_group.public_ec2.id]
  key_name               = var.key_name != "" ? var.key_name : null

  user_data = var.public_user_data

  tags = merge(var.tags, {
    Name = "${var.project_name}-public-ec2-${count.index + 1}"
    Tier = "public"
  })
}


resource "aws_instance" "private" {
  count                  = length(var.private_subnet_ids)
  ami                    = local.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[count.index]
  vpc_security_group_ids = [aws_security_group.private_ec2.id]
  key_name               = var.key_name != "" ? var.key_name : null

  user_data = var.private_user_data

  tags = merge(var.tags, {
    Name = "${var.project_name}-private-ec2-${count.index + 1}"
    Tier = "private"
  })
}
