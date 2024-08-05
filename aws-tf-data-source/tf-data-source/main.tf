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


# # Availability Zones
# data "aws_availability_zones" "names" {
#   state = "available"
# }
# output "availability_zones" {
#   value = data.aws_availability_zones.names  
# }

# # To get account details
# data "aws_caller_identity" "name" { 
# }
# output "info" {
#   value = data.aws_caller_identity.name
# }
# data "aws_region" "name" {
# }
# output "region_name" {
#   value = data.aws_region.name
# }


# Security Group
data "aws_security_group" "name" {
  tags = {
    Name = "my-security-group"
  }
}
output "Security-Group" {
  value = data.aws_security_group.name.id
}

# VPC ID
data "aws_vpc" "name" {
  tags = {
    Name = "my-vpc"
  }
}
output "VPC-ID" {
  value = data.aws_vpc.name.id
}

# Subnet ID
data "aws_subnet" "name" {
  filter {
    name = "vpc-id"
    values = [ data.aws_vpc.name.id ]
  }
  tags = {
    Name = "private-subnet"
  }
}
output "Subnet-ID" {
  value = data.aws_subnet.name.id
}


#Configure the AWS ec2 instance
resource "aws_instance" "myServer" {
  ami           = "ami-0ff591da048329e00"
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.name.id
  security_groups = [ data.aws_security_group.name.id ]

  tags = {
    Name : "SampleServer"
  }
}