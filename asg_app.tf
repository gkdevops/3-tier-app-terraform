resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-app-"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.app.id]
  }

  user_data = base64encode(
    templatefile("${path.module}/user_data/user_data_app.sh",
      {
        DB_HOST  = aws_db_instance.postgres.address
        DB_NAME  = var.db_name
        DB_USER  = var.db_username
        DB_PASS  = var.db_password
        APP_PORT = var.app_port
      }
    )
  )
  lifecycle { create_before_destroy = true }
}

resource "aws_autoscaling_group" "app" {
  name                = "${var.project_name}-app-asg"
  min_size            = 1
  max_size            = 3
  desired_capacity    = 2
  vpc_zone_identifier = var.private_app_subnet_ids

  launch_template { id = aws_launch_template.app.id version = "$Latest" }

  target_group_arns   = [aws_lb_target_group.app_tg.arn]
  health_check_type   = "ELB"
  depends_on          = [aws_db_instance.postgres]
}
