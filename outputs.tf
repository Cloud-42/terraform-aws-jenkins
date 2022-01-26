output "asg_id" {
  description = "Jenkins ASG id"
  value       = [aws_autoscaling_group.jenkins.id]
}

output "efs_dns_name" {
  description = "DNS name of the EFS share"
  value       = aws_efs_file_system.this.dns_name
}

output "efs_id" {
  description = "ID of the EFS share"
  value       = aws_efs_file_system.this.id
}

output "lb_arn" {
  description = "Load balancer ARN"
  value       = aws_lb.jenkins.arn
}

output "lb_dns_name" {
  description = "Load balancer DNS Name"
  value       = aws_lb.jenkins.dns_name
}

output "lb_zone_id" {
  description = "Load balancer zone id"
  value       = aws_lb.jenkins.zone_id
}