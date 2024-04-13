
resource "aws_lb" "demo-lb-alb" {
  name               = "demo-lb-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.subnets # Substitua pelos IDs das subnets desejadas

  enable_deletion_protection = false

  tags = {
    Name = "my-lb-alb-terraform"
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

#role exemplo para rota especifica /login
resource "aws_lb_listener_rule" "login_rule" {
  listener_arn = aws_lb.demo-lb-alb.arn
  priority     = 100

  action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Esta é uma mensagem de exemplo para a rota /login"
      status_code  = "200"
    }
  }

  condition {
    path_pattern {
      values = ["/login*"]  # Qualquer rota que comece com /login
    }
  }
}

