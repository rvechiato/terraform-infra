variable "ami_id" {
  description = "AMI ID for EC2 instance"
}

variable "instance_type" {
  description = "Instance type for EC2 instance"
}

variable "vpc_id" {
  description = "ID da VPC onde a instância EC2 será lançada"
  type        = string
}

variable "subnet" {
  description = "Instance type for EC2 instance"
}


variable "availability_zone" {
  description = "Availability Zone where the EC2 instance will be launched"
  type        = string
  default     = "us-east-1a"  # Substitua pelo valor da zona de disponibilidade desejada
}

variable "instance_count" {
  description = "Número de instâncias EC2 a serem criadas"
  type        = number
  default = 1
}

variable "alb_security_group_id" {
  description = "Alb Security group"  
}


