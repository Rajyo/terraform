variable "ec2_instance_type" {}
variable "ec2_ami_id" {}
variable "ec2_sg_id" {}
variable "private_subnet_id" {}
variable "alb_ec2_tg_arn" {}


resource "aws_launch_template" "ec2_launch_template" {
  name = "my-web-server-lt"

  image_id      = var.ec2_ami_id
  instance_type = var.ec2_instance_type

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.ec2_sg_id]
  }

  user_data = <<EOF
#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>This message from apache webserver : $(hostname -i)</h1>" > /var/www/html/index.html
EOF

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "my-ec2-web-server-lt"
    }
  }
}


resource "aws_autoscaling_group" "ec2_asg" {
  name                = "my-web-server-asg"
  desired_capacity    = 2
  min_size            = 1
  max_size            = 3
  target_group_arns   = [var.alb_ec2_tg_arn]
  vpc_zone_identifier = var.private_subnet_id

  launch_template {
    id      = aws_launch_template.ec2_launch_template.id
    version = "$Latest"
  }

  health_check_type = "EC2"
}
