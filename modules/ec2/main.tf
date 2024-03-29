resource "aws_security_group" "demo-sg-ec2" {
  name        = "demo-sg-ec2"
  description = "Security group for example instance"

  vpc_id = var.vpc_id  # Substitua pelo ID da VPC onde o grupo de segurança será criado

  // Regra de entrada permitindo acesso HTTP na porta 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permitindo acesso de qualquer lugar
  }

  // Regra de entrada permitindo acesso SSH na porta 22
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permitindo acesso de qualquer lugar
  }

  // Regra de saída permitindo todo tráfego
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-demo-sg-ec2"
  }
}


resource "aws_instance" "ec2-demo-instance" {
  ami                    = var.ami_id  # Substitua pelo ID da AMI desejada
  
  instance_type          = var.instance_type      # Tipo da instância
  security_groups        = [aws_security_group.demo-sg-ec2.id]  # Referência ao ID do grupo de segurança criado acima
  associate_public_ip_address = true       # Habilitar IP público 
  user_data              = local.userdata_script  # Usar o script UserData definido no recurso local
  subnet_id              = var.subnet  
  availability_zone      = var.availability_zone 
  
  depends_on = [aws_security_group.demo-sg-ec2]

  tags = {
    Name = "my-demo-ec2-instances"
  }
}

