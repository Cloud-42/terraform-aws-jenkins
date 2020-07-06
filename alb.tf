# --------------------------
# Jenkins ALB
# --------------------------
resource "aws_lb" "jenkins" {
  # only hyphens are allowed in name 
  name = "${var.environment}-jenkins-alb"

  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  internal                         = var.internal
  load_balancer_type               = "application"
  security_groups                  = var.security_groups_alb
  subnets                          = var.subnets

  enable_deletion_protection = var.enable_deletion_protection

  tags = var.tags
}

