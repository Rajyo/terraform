provider "aws" {
  region = "us-west-1"
}

module "my-custom-vpc" {
  source = "./vpc-module"

  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "my-vpc"
  }

  subnet_config = {
    #key={cidr, az}
    public_subnet1 = {
      cidr_block = "10.0.0.0/24"
      az         = "us-west-1b"
      public     = true
    }

    public_subnet2 = {
      cidr_block = "10.0.2.0/24"
      az         = "us-west-1b"
      public     = true
    }

    private_subnet = {
      cidr_block = "10.0.1.0/24"
      az         = "us-west-1c"
    }
  }
}
