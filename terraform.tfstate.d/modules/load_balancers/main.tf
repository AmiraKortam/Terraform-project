resource "aws_lb" "public_alb" {
  name               = "public-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets           = var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "public-alb"
  }
}

resource "aws_lb" "internal_alb" {
  name               = "internal-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.internal_alb_sg_id]
  subnets           = var.private_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "internal-alb"
  }
}
