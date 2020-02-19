# --------------------------
# Create scheduled action to rebuild Jenkins host,
# ensuring Jenkins is updated on a schedule.
# --------------------------

resource "aws_autoscaling_schedule" "scale_down" {
  count                  = var.autoscaling_schedule_create != 0 ? 1 : 0
  scheduled_action_name  = "scale_down"
  min_size               = 0
  max_size               = 0
  desired_capacity       = 0
  recurrence             = var.scale_down_cron
  autoscaling_group_name = aws_autoscaling_group.jenkins.name
}

resource "aws_autoscaling_schedule" "scale_up" {
  count                  = var.autoscaling_schedule_create != 0 ? 1 : 0
  scheduled_action_name  = "scale_up"
  min_size               = 1
  max_size               = 1
  desired_capacity       = 1
  recurrence             = var.scale_up_cron
  autoscaling_group_name = aws_autoscaling_group.jenkins.name
}

