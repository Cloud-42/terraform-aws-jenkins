# --------------------------
# Jenkins Auto-Scaling Group
# --------------------------
resource "aws_autoscaling_group" "jenkins" {
  depends_on = [aws_efs_file_system.this, aws_launch_configuration.jenkins]

  name                      = "${var.environment}_jenkins_asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  launch_configuration      = aws_launch_configuration.jenkins.name
  vpc_zone_identifier       = var.vpc_zone_identifier
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type

  tags var.tags 
}
