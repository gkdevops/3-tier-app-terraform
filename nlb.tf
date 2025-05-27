resource "aws_lb" "public_nlb" {
  name               = "${var.project_name}-public-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.public_nlb.id]  # allowed since NLB SG support (2023)
}

resource "aws_lb_target_group" "web_tg" {
  name     = "${var.project_name}-web-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = var.vpc_id
  target_type = "instance"
}

resource "aws_lb_listener" "public_http" {
  load_balancer_arn = aws_lb.public_nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action { 
    type="forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}
