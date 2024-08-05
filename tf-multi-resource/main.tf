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

locals {
  project = "project-01"
}

# Configuring VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-${local.project}-vpc"
  }
}

# Configuring 2 Subnets
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.${count.index}.0/24"
  count      = 2
  tags = {
    Name = "main-${local.project}-subnet-${count.index}"
  }
}
output "aws_subnet_id" {
  value = aws_subnet.main[*].id
}

# #Configuring 4 ec2 instances
# resource "aws_instance" "my_ec2_instance" {
#   ami           = "ami-0ff591da048329e00"
#   instance_type = "t2.micro"
#   count         = 4
#   subnet_id = element(aws_subnet.main[*].id, count.index % length(aws_subnet.main))

#   tags = {
#     Name = "my-${local.project}-ec2-instance-${count.index}"
#   }
# }



####### LIST #######
# # Configuring 2 ec2 instance
# resource "aws_instance" "my_ec2_instance" {
#   count         = length(var.aws_ec2_config)
#   ami           = var.aws_ec2_config[count.index].ami
#   instance_type = var.aws_ec2_config[count.index].instance_type
#   subnet_id     = element(aws_subnet.main[*].id, count.index % length(aws_subnet.main))

#   tags = {
#     Name = "my-${local.project}-ec2-instance-${count.index}"
#   }
# }


####### MAP #######
# Configuring 2 ec2 instance
resource "aws_instance" "my_ec2_instance" {
  for_each = var.aws_ec2_map
  # we will get each.key and each.value
  ami           = each.value.ami
  instance_type = each.value.instance_type
  subnet_id     = element(aws_subnet.main[*].id, index(keys(var.aws_ec2_map), each.key) % length(aws_subnet.main))

  tags = {
    Name = "my-${local.project}-ec2-instance-${each.key}"
  }
}
