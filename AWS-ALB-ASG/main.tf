module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}


module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}


module "alb" {
  source           = "./modules/alb"
  public_subnet_id = module.vpc.public_subnet_id
  aws_alb_sg_id    = module.sg.aws_alb_sg_id
  igw_vpc          = module.vpc.igw_vpc
  vpc_id           = module.vpc.vpc_id
}


module "asg" {
  source            = "./modules/asg"
  ec2_instance_type = var.ec2_instance_type
  ec2_ami_id        = var.ec2_ami_id
  ec2_sg_id         = module.sg.aws_ec2_sg_id
  private_subnet_id = module.vpc.private_subnet_id
  alb_ec2_tg_arn    = module.alb.alb_ec2_tg_arn
}