output "asg_id" {
  description = "Jenkins ASG id"
  value       = ["${aws_autoscaling_group.jenkins.id}"]
}

output "ec2_ssh_sg" {
  description = "Security Group id that controls ssh access"
  value       = "${aws_security_group.ec2_ssh_sg.id}"
}

output "ec2_sg" {
  description = "Security Group id that controls access to the ec2 host"
  value       = "${aws_security_group.ec2_sg.id}"
}

output "efs_dns_name" {
  description = "DNS name of the EFS share"
  value       = "${aws_efs_file_system.this.dns_name}"
}
