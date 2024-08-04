resource "aws_instance" "nginx_server" {
  ami                    = "ami-0ff591da048329e00"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.nginx_security_group.id]
  associate_public_ip_address = true

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update
                sudo apt install nginx -y
                sudo systemctl start nginx
                EOF

  tags = {
    Name = "nginx-server"
  }
}

