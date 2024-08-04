terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.2"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

resource "random_id" "r_id" {
  byte_length = 8
}

resource "aws_s3_bucket" "trial-bucket" {
  bucket = "trial-bucket-${random_id.r_id.hex}"
}

resource "aws_s3_object" "bucket-data" {
  bucket = aws_s3_bucket.trial-bucket.bucket
  source = "./myFile.txt"
  key    = "mydata.txt"
}
