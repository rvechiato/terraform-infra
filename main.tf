
provider "aws" {
  region = "us-east-1"  # Substitua pela região desejada
  access_key  =  var.access_key
  secret_key  =  var.secret_key
}

# VPC existente
data "aws_vpc" "vpc_id" {
  id = "vpc-098438d41a49e28be" 
}

# Sub-rede existente
data "aws_subnet" "existing_subnet" {
  vpc_id = "vpc-098438d41a49e28be" 
  id     = "subnet-0898c7b4226bee9e3"
}

module "ec2_instance" {
  source = "./modules/ec2"

  ami_id        = var.ami_id
  instance_type = var.instance_type
  vpc_id        = data.aws_vpc.vpc_id.id
}