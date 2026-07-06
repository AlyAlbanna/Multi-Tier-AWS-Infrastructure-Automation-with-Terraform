
resource "aws_security_group" "external_alb" {
  name        = "${var.project_name}-external-alb-sg"
  description = "Allow inbound HTTP/HTTPS from the internet"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-external-alb-sg"
  })
}

resource "aws_security_group" "internal_alb" {
  name        = "${var.project_name}-internal-alb-sg"
  description = "Allow inbound HTTP only from the public tier (proxy tier)"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from public tier EC2 instances"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-internal-alb-sg"
  })
}

resource "aws_lb" "external" {
  name               = "${var.project_name}-ext-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.external_alb.id]
  subnets            = var.public_subnet_ids

  tags = merge(var.tags, {
    Name = "${var.project_name}-ext-alb"
  })
}

resource "aws_lb_target_group" "public" {
  name     = "${var.project_name}-public-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 5
    interval            = 30
    timeout             = 5
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-public-tg"
  })
}

resource "aws_lb_listener" "external_http" {
  load_balancer_arn = aws_lb.external.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public.arn
  }
}


resource "aws_lb" "internal" {
  name               = "${var.project_name}-int-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.internal_alb.id]
  subnets            = var.private_subnet_ids

  tags = merge(var.tags, {
    Name = "${var.project_name}-int-alb-proxy"
  })
}

resource "aws_lb_target_group" "private" {
  name     = "${var.project_name}-private-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 5
    interval            = 30
    timeout             = 5
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-private-tg"
  })
}

resource "aws_lb_listener" "internal_http" {
  load_balancer_arn = aws_lb.internal.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private.arn
  }
}
