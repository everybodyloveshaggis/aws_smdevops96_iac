# alb.tf
resource "aws_lb" "app_alb" {
  name               = "app-load-balancer"
  internal           = false
  load_balancer_type = "application"

  subnets         = [aws_subnet.public1.id, aws_subnet.public2.id]
  security_groups = [aws_security_group.alb_sg.id]
}

resource "aws_lb_target_group" "nextjs" {
  name        = "nextjs-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nextjs.arn
  }
}