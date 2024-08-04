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

provider "aws" {
  region = "us-east-1"
}

resource "random_id" "r_id" {
  byte_length = 8
}

resource "aws_s3_bucket" "web-hosting-bucket" {
  bucket = "web-hosting-bucket-${random_id.r_id.hex}"
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket                  = aws_s3_bucket.web-hosting-bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.web-hosting-bucket.id
  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Sid = "PublicReadGetObject",
          Effect = "Allow",
          Principal = "*",
          Action = "s3:GetObject",
          Resource = "arn:aws:s3:::${aws_s3_bucket.web-hosting-bucket.id}/*"
        }
      ]
    }
  )
}

resource "aws_s3_bucket_website_configuration" "web_hosting_bucket" {
  bucket = aws_s3_bucket.web-hosting-bucket.id
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.web-hosting-bucket.bucket
  source = "./index.html"
  key    = "index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "style_css" {
  bucket = aws_s3_bucket.web-hosting-bucket.bucket
  source = "./style.css"
  key    = "style.css"
  content_type = "text/css"
}

output "name" {
  value = aws_s3_bucket_website_configuration.web_hosting_bucket.website_endpoint
}