resource "aws_db_subnet_group" "db" {
  name       = "${var.project_name}-db-sng"
  subnet_ids = var.private_db_subnet_ids
}

resource "aws_db_instance" "postgres" {
  identifier_prefix = "${var.project_name}-pg-"
  engine            = "postgres"
  engine_version    = "16.8"
  instance_class    = "db.m7g.xlarge"

  allocated_storage      = 200
  db_subnet_group_name   = aws_db_subnet_group.db.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  username = var.db_username
  password = var.db_password
  db_name  = var.db_name

  skip_final_snapshot = true  # change to false for prod
  deletion_protection = false # change to true for prod
  multi_az            = false # true for HA
}
