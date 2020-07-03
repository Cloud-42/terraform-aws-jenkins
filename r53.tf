# --------------------------
# Route 53 entry for the ALB
# --------------------------
resource "aws_route53_record" "alb" {
  count = var.create_dns_record ? 1 : 0
  # Endpoint DNS record

  zone_id = var.zone_id
  name    = var.route53_endpoint_record
  type    = "CNAME"
  ttl     = "300"

  # matches up record N to instance N
  records = [aws_lb.jenkins.dns_name]
}

