# --------------------------
# Jenkins ALB
# --------------------------
resource "aws_lb" "jenkins" {
  # only hyphens are allowed in name 
  name = "${var.environment}-jenkins-alb"

  enable_cross_zone_load_balancing = "${var.enable_cross_zone_load_balancing}"
  internal                         = "${var.internal}"
  load_balancer_type               = "application"
  security_groups                  = ["${aws_security_group.alb_sg.id}"]
  subnets                          = ["${split(",",var.subnets)}"]

  enable_deletion_protection = "${var.enable_deletion_protection}"

  tags {
    "Environment"   = "${var.environment}"
    "Contact"       = "${var.contact}"
    "Orchestration" = "${var.orchestration}"
  }
}
