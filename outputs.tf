output "primary_aws_efs_mount_target" {
  description = "IP address of primary EFS mount target"
  value       = aws_efs_mount_target.private_subnet_a.ip_address
}

output "asg_id" {
  description = "Jenkins ASG id"
  value       = [aws_autoscaling_group.jenkins.id]
}

output "efs_dns_name" {
  description = "DNS name of the EFS share"
  value       = aws_efs_file_system.this.dns_name
}

