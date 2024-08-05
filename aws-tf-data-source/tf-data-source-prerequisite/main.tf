terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"
}

# Configure the VPC
resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "my-vpc"
  }
}

# Configure Private Subnet inside VPC
resource "aws_subnet" "private_subnet" {
  cidr_block = "10.0.0.0/28"
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "private-subnet"
  }
}

# Configure Security Group
 resource "aws_security_group" "my_security_group" {
   vpc_id = aws_vpc.my-vpc.id
   ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   }
   egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
   }
   tags = {
     Name = "my-security-group"
   }
 }