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


# locals {
#   name = "SampleServer"
#   owner = "BATMAN"
# }
locals {
  common_tags = {
    name  = "SampleServer"
    owner = "BATMAN"
  }
}

#Configure the AWS ec2 instance
resource "aws_instance" "myServer" {
  ami           = "ami-0ff591da048329e00"
  instance_type = var.aws_instance_type

  root_block_device {
    delete_on_termination = true
    volume_size           = var.ec2_root_block_config.v_size
    volume_type           = var.ec2_root_block_config.v_type
  }

  # tags = merge(var.additional_tags, {
  #   Name = local.name
  #   Owner = local.owner
  #   }
  # )
  tags = merge(var.additional_tags, local.common_tags
  )
}