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
  id     = var.subnet
}

module "ec2_instance" {
  source = "./modules/ec2"

  ami_id        = var.ami_id
  instance_type = var.instance_type
  subnet        = var.subnet
  vpc_id        = var.my_vpc_id
}
