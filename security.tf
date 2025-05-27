#######################################
# Public NLB SG (ingress :80/443 world)
#######################################
resource "aws_security_group" "public_nlb" {
  name   = "${var.project_name}-public-nlb-sg"
  vpc_id = var.vpc_id

  ingress { protocol = "tcp" from_port = 80  to_port = 80  cidr_blocks = ["0.0.0.0/0"] }
  #ingress { protocol = "tcp" from_port = 443 to_port = 443 cidr_blocks = ["0.0.0.0/0"] }
  egress  { protocol = "-1"  from_port = 0   to_port = 0   cidr_blocks = ["0.0.0.0/0"] }
}

#######################################
# Web EC2 SG
#######################################
resource "aws_security_group" "web" {
  name   = "${var.project_name}-web-sg"
  vpc_id = var.vpc_id

  # traffic FROM NLB (we allow via subnet CIDRs to keep it simple)
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = var.public_subnet_cidrs
  }

  # SSH – tighten in production
  ingress { protocol="tcp" from_port=22 to_port=22 cidr_blocks=["0.0.0.0/0"] }

  egress  { protocol="-1" from_port=0 to_port=0 cidr_blocks=["0.0.0.0/0"] }
}

#######################################
# Internal NLB SG
#######################################
resource "aws_security_group" "internal_nlb" {
  name   = "${var.project_name}-internal-nlb-sg"
  vpc_id = var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = var.app_port
    to_port         = var.app_port
    security_groups = [aws_security_group.web.id]  # Web SG is the source
  }

  egress { protocol="-1" from_port=0 to_port=0 cidr_blocks=["0.0.0.0/0"] }
}

#######################################
# App EC2 SG
#######################################
resource "aws_security_group" "app" {
  name   = "${var.project_name}-app-sg"
  vpc_id = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = var.app_port
    to_port     = var.app_port
    cidr_blocks = var.private_app_subnet_cidrs
  }

  egress { protocol="-1" from_port=0 to_port=0 cidr_blocks=["0.0.0.0/0"] }
}

#######################################
# RDS SG
#######################################
resource "aws_security_group" "rds" {
  name   = "${var.project_name}-rds-sg"
  vpc_id = var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = 5432
    to_port         = 5432
    security_groups = [aws_security_group.app.id]
  }
}

