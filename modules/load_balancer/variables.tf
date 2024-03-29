variable "target_group_arn" {
  description = "ID do Security Group do Load Balancer"
}

variable "subnets" {
  description = "Lista de IDs das Subnets onde o Load Balancer será lançado"
}


variable "vpc_id" {
  description = "ID da VPC onde a instância EC2 será lançada"
  type        = string
}