
resource "aws_lb" "demo-lb-alb" {
  name               = "demo-lb-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.demo-sg-lb.id]
  subnets            = var.subnets # Substitua pelos IDs das subnets desejadas

  enable_deletion_protection = false

  depends_on = [aws_security_group.demo-sg-lb]

  tags = {
    Name = "my-lb-alb-terraform"
  }
}

resource "aws_security_group" "demo-sg-lb" {
  name        = "demo-lb-sg"
  description = "Security group for load balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  

  tags = {
    Name = "my-demo-sg-lb"
  }
}

resource "aws_lb_listener" "my-demo-lb-listener" {
  load_balancer_arn = aws_lb.demo-lb-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }
}


