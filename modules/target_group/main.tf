resource "aws_lb_target_group" "my-demo-tg-alb" {
  name     = "example-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id  # Substitua pelo ID da VPC onde estão as instâncias EC2

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group_attachment" "my-lb-tg-att" {
  for_each = { for idx, instance_id in var.instances : idx => instance_id }

  target_group_arn = aws_lb_target_group.my-demo-tg-alb.arn
  target_id       = each.value
  port            = 80
}