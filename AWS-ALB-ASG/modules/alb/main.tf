variable "aws_alb_sg_id" {}
variable "public_subnet_id" {}
variable "igw_vpc" {}
variable "vpc_id" {}


output "alb_ec2_tg_arn" {
  value = aws_lb_target_group.alb_ec2_tg.arn
}

output "alb_dns_name" {
  value = aws_lb.app_lb.dns_name
}


resource "aws_lb" "app_lb" {
  name               = "my-app-lb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [var.aws_alb_sg_id]
  subnets            = var.public_subnet_id
  depends_on         = [var.igw_vpc]
}

resource "aws_lb_target_group" "alb_ec2_tg" {
  name     = "my-web-server-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  tags = {
    Name = "my-alb_ec2_tg"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_ec2_tg.arn
  }
  tags = {
    Name = "my-alb-listener"
  }
}
