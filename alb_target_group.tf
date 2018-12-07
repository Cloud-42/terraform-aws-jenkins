# --------------------------
# ALB target group
# --------------------------
resource "aws_lb_target_group" "alb_target_group" {
  name     = "jenkins-${var.environment}-tg"
  port     = "${var.svc_port}"
  protocol = "${var.target_group_protocol}"
  vpc_id   = "${var.vpc_id}"

  health_check {
    healthy_threshold   = "${var.healthy_threshold}"
    unhealthy_threshold = "${var.unhealthy_threshold}"
    timeout             = "${var.timeout}"
    interval            = "${var.interval}"
    matcher             = "${var.success_codes}"

    path = "${var.target_group_path}"
    port = "${var.target_group_port}"
  }
}
