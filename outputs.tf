output "public_nlb_dns" { value = aws_lb.public_nlb.dns_name }
output "internal_nlb_dns" { value = aws_lb.internal_nlb.dns_name }
output "rds_endpoint" { value = aws_db_instance.postgres.address }
output "application_url" { value = "http://${var.domain_name}" }
