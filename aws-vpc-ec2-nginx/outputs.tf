output "instance_public_ip" {
  description = "The public IP address of the ec2 instance"
  value = aws_instance.nginx_server.public_ip
}

output "instance_url" {
  description = "The URL to access the Nginx server"
  value = "http://${aws_instance.nginx_server.public_ip}"
}