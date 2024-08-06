terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-1"
}

variable "instance_type" {
  type = map(string)
  default = {
    "dev"   = "t2.micro"
    "stage" = "t2.medium"
    "prod"  = "t2.large"
  }
}

resource "random_id" "r_id" {
  byte_length = 8
}

resource "aws_s3_bucket" "workspace-bucket" {
  bucket = "workspace-bucket-${terraform.workspace}-${random_id.r_id.hex}"
}

resource "aws_instance" "my_server" {
  ami           = "ami-0ff591da048329e00"
  instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")

  tags = {
    Name : "my-${terraform.workspace}-server"
  }
}
