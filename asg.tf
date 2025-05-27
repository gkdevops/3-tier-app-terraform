data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter { name="name" values=["amzn2-ami-hvm-*-x86_64-gp2"] }
}

resource "aws_launch_template" "web" {
  name_prefix   = "${var.project_name}-web-"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.web.id]
  }

  user_data = base64encode(
    templatefile("${path.module}/user_data/user_data_web.sh",
      {
        INTERNAL_NLB_DNS = aws_lb.internal_nlb.dns_name
        APP_PORT         = var.app_port
      }
    )
  )

  lifecycle { create_before_destroy = true }
}

resource "aws_autoscaling_group" "web" {
  name                = "${var.project_name}-web-asg"
  min_size            = 1
  max_size            = 3
  desired_capacity    = 2
  vpc_zone_identifier = var.public_subnet_ids

  launch_template { id = aws_launch_template.web.id version = "$Latest" }

  target_group_arns = [aws_lb_target_group.web_tg.arn]
  health_check_type = "ELB"
}

