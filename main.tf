provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/aws-vpc"
  availability_zones_count = var.availability_zones_count
}

module "eks" {
  source = "./modules/aws-eks"
  vpc_id = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnets
  private_subnet_id = module.vpc.private_subnets
  cluster_name =  module.eks.cluster_name
}

module "private_docker_registry" {
  source = "./modules/aws-ecr"
  repo_name = var.ecr_name
}

module "mysql" {
  source = "./modules/aws-mysql"
  db-sg-id = module.vpc.db_sg_id
}