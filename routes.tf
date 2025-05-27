resource "aws_route53_record" "app_a_record" {
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.public_nlb.dns_name
    zone_id                = aws_lb.public_nlb.zone_id
    evaluate_target_health = true
  }
}
