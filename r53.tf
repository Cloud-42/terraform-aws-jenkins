# --------------------------
# Route 53 entry for the ALB
# --------------------------

resource "aws_route53_record" "alb" {
  # Endpoint DNS record

  zone_id = "${var.zone_id}"
  name    = "jenkins"
  type    = "CNAME"
  ttl     = "300"

  # matches up record N to instance N
  records = ["${aws_lb.jenkins.dns_name}"]
}
