provider "aws" {
  region      = var.region # Substitua pela região desejada
  access_key  =  var.access_key
  secret_key  =  var.secret_key
}

# VPC existente
data "aws_vpc" "my_vpc" { 
  id = var.my_vpc_id
}

# Sub-rede existente
data "aws_subnet" "my_subnet" {
  vpc_id = data.aws_vpc.my_vpc.id
  id     = var.subnet_one
}

module "ec2_instances" {
  source = "./modules/ec2"

  ami_id        = var.ami_id
  instance_type = var.instance_type
  subnet        = var.subnet_one
  vpc_id        = var.my_vpc_id
}

module "load_balancer" {
  source              = "./modules/load_balancer"
  target_group_arn    = module.target_group.arn
  subnets             = [var.subnet_one, var.subnet_two]  # Substitua pelos IDs das subnets desejadas
  vpc_id              = var.my_vpc_id

  depends_on = [ module.target_group ]
}

module "target_group" {
  source              = "./modules/target_group"
  target_group_name   = "example-target-group"
  vpc_id              = var.my_vpc_id  # Substitua pelo ID da VPC onde estão as instâncias EC2
  subnet              = var.subnet_one
  instances           = [module.ec2_instances.instance_id]

  depends_on = [ module.ec2_instances ]
}  