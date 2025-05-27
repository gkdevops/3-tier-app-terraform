resource "aws_lb" "internal_nlb" {
  name               = "${var.project_name}-internal-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.private_app_subnet_ids
  security_groups    = [aws_security_group.internal_nlb.id]
}

resource "aws_lb_target_group" "app_tg" {
  name         = "${var.project_name}-app-tg"
  port         = var.app_port
  protocol     = "TCP"
  vpc_id       = var.vpc_id
  target_type  = "instance"
}

resource "aws_lb_listener" "internal_listener" {
  load_balancer_arn = aws_lb.internal_nlb.arn
  port              = var.app_port
  protocol          = "TCP"
  default_action { type="forward" target_group_arn = aws_lb_target_group.app_tg.arn }
}
