# --------------------------
#  ALB target group attachment
# --------------------------
resource "aws_autoscaling_attachment" "asg_attachment" {
  depends_on = [aws_autoscaling_group.jenkins]

  autoscaling_group_name = aws_autoscaling_group.jenkins.id
  alb_target_group_arn   = aws_lb_target_group.alb_target_group.arn
}
