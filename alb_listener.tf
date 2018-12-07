# --------------------------
# ALB Listener
# --------------------------
resource "aws_alb_listener" "alb_listener" {
  depends_on        = ["aws_autoscaling_group.jenkins"]
  load_balancer_arn = "${aws_lb.jenkins.arn}"
  port              = "${var.alb_listener_port}"
  protocol          = "${var.alb_listener_protocol}"
  certificate_arn   = "${var.certificate_arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.alb_target_group.arn}"
    type             = "forward"
  }
}
