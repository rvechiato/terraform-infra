
provider "aws" {
  region = "us-east-1"  # Substitua pela região desejada
  access_key  =  var.access_key
  secret_key  =  var.secret_key
}

# VPC existente
data "aws_vpc" "vpc_id" {
  id = var.vpc_id
}

# Sub-rede existente
data "aws_subnet" "existing_subnet" {
  vpc_id = data.aws_vpc.vpc_id.id 
  id     = var.subnet
}

module "ec2_instance" {
  source = "./modules/ec2"

  ami_id        = var.ami_id
  instance_type = var.instance_type
  vpc_id        = data.aws_vpc.vpc_id.id
}
