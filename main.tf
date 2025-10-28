provider "aws" {
  region = var.region
}

module "vpc" {
  source               = "./modules/vpc"
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "nat_gateway" {
  source            = "./modules/nat_gateway"
  vpc_id            = module.vpc.vpc_id
  public_subnet_id  = module.vpc.public_subnet_ids[0]  
  private_subnet_ids = module.vpc.private_subnet_ids
}


module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "efs" {
  source             = "./modules/efs"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "asg" {
  source               = "./modules/asg"
  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  alb_target_group_arn = module.alb.target_group_arn
  alb_sg_id            = module.alb.alb_sg_id
  efs_id               = module.efs.efs_id
  efs_dns_name         = module.efs.efs_dns_name

}

module "rds" {
  source             = "./modules/rds"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  db_username        = var.db_username
  db_password        = var.db_password
}

module "route53" {
  source         = "./modules/route53"
  domain_name    = var.domain_name
  alb_dns_name   = module.alb.dns_name
  alb_zone_id    = module.alb.alb_zone_id
}
