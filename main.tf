provider "aws" {
  region      = var.region # Substitua pela região desejada
  access_key  =  var.access_key
  secret_key  =  var.secret_key
}

#Criar VPC de forma dinamica
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"  # ou "dedicated" se necessário

  tags = {
    Name = "my-vpc"
  }
}

# Criação do Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id  # Referência para a VPC onde o IGW será anexado

  tags = {
    Name = "my-internet-gateway"
  }
}

# Criação da rota para a Internet na tabela de rotas da VPC
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.my_vpc.default_route_table_id  # Referência para a tabela de rotas padrão da VPC
  destination_cidr_block = "0.0.0.0/0"  # Rota para a Internet
  gateway_id             = aws_internet_gateway.my_igw.id  # Referência para o IGW
}


#Criar subnets de forma dinamica
resource "aws_subnet" "subnet_one" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"  # Substitua pela AZ desejada

  tags = {
    Name = "subnet-one"
  }
}

resource "aws_subnet" "subnet_two" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"  # Substitua pela AZ desejada

  tags = {
    Name = "subnet-two"
  }
}

# criar security group for alb
module "alb_security_group" {
  source = "./modules/security_gorup"
  vpc_id = aws_vpc.my_vpc.id
  subnets = aws_subnet.subnet_one.id
}

module "ec2_instances" {
  source = "./modules/ec2"

  ami_id                = var.ami_id
  instance_type         = var.instance_type
  subnet                = aws_subnet.subnet_one.id
  vpc_id                = aws_vpc.my_vpc.id
  alb_security_group_id = module.alb_security_group.id

}

module "load_balancer" {
  source              = "./modules/load_balancer"
  target_group_arn    = module.target_group.arn
  subnets             = [aws_subnet.subnet_one.id, aws_subnet.subnet_two.id]  # Substitua pelos IDs das subnets desejadas
  vpc_id              = aws_vpc.my_vpc.id
  
  alb_security_group_id = module.alb_security_group.id

  depends_on = [ module.target_group ]
}

module "target_group" {
  source              = "./modules/target_group"
  target_group_name   = "example-target-group"
  vpc_id              = aws_vpc.my_vpc.id  # Substitua pelo ID da VPC onde estão as instâncias EC2
  subnet              = aws_subnet.subnet_one.id
  instances           = [module.ec2_instances.instance_id]

  depends_on = [ module.ec2_instances ]
}  