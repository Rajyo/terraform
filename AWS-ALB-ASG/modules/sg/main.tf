variable "vpc_id" {}


output "aws_alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "aws_ec2_sg_id" {
  value = aws_security_group.ec2_sg.id
}


resource "aws_security_group" "alb_sg" {
  name        = "my-alb-sg"
  description = "Security Group for Application Load Balancer"

  vpc_id = var.vpc_id

  ingress {
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

  tags = {
    Name = "My ALB Security Group"
  }
}


resource "aws_security_group" "ec2_sg" {
  name        = "my-ec2-sg"
  description = "Security Group for Web Server Instances"

  vpc_id = var.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "My EC2 Security Group"
  }
}
