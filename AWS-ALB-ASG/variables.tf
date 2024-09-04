variable "vpc_cidr" {
  description = "VPC_CIDR_Range"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Public_Subnets_CIDR_Range"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private_Subnets_CIDR_Range"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability_Zones"
  type        = list(string)
}

variable "ec2_instance_type" {
  description = "EC2 Instance Type"
  type        = string
}

variable "ec2_ami_id" {
  description = "EC2 AMI ID"
  type        = string
}