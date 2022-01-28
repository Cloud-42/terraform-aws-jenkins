variable "custom_userdata" {
  description = "Set custom userdata"
  type        = string
  default     = ""
}
variable "create_dns_record" {
  description = "Create friendly DNS CNAME"
  type        = bool
  default     = true
}
variable "security_groups" {
  description = "List of security groups to assign to the ec2 instance. Create outside of module and pass in"
  type        = list(string)
}
variable "tags" {
  description = "Tags map"
  type        = map(string)
  default     = {}
}
variable "asg_tags" {
  type        = any
  description = "Dynamic tags for ASG"
  default = [{
    key                 = "Name"
    value               = "tags need setting"
    propagate_at_launch = true
  }]
}
variable "preliminary_user_data" {
  type        = string
  description = "Preliminary shell script commands for adding to user data.Runs at the beginning of userdata"
  default     = "#preliminary_user_data"
}
variable "supplementary_user_data" {
  type        = string
  description = "Supplementary shell script commands for adding to user data.Runs at the end of userdata"
  default     = "#supplementary_user_data"
}
variable "iam_instance_profile" {
  type        = string
  description = "IAM instance profile for Jenkins server"
  default     = null
}
variable "autoscaling_schedule_create" {
  type        = number
  description = "Allows for disabling of scheduled actions on ASG. Enabled by default"
  default     = 1
}
variable "route53_endpoint_record" {
  type        = string
  description = "Route 53 endpoint name. Creates route53_endpoint_record "
  default     = "jenkins"
}
variable "ami" {
  type        = string
  description = "AMI to be used to build the ec2 instance (via launch config)"
}
variable "success_codes" {
  description = "Success Codes for the Target Group Health Checks. Default is 200 ( OK )"
  type        = string
  default     = "200"
}
variable "security_groups_alb" {
  type        = list(string)
  description = "ALB Security Group. Create outside of module and pass in"
}
variable "certificate_arn" {
  type        = string
  description = "ARN of the SSL certificate to use"
}
variable "vpc_id" {
  type        = string
  description = "VPC id"
}
variable "environment" {
  type        = string
  description = "Environment where resources are being created, for example DEV, UAT or PROD"
}
variable "key_name" {
  type        = string
  description = "ec2 key pair use"
}
variable "instance_type" {
  type        = string
  description = "ec2 instance type"
  default     = "t3a.medium"
}
variable "hostname_prefix" {
  type        = string
  description = "Hostname prefix for the Jenkins server"
  default     = "jenkins"
}
variable "domain_name" {
  type        = string
  description = "Domain Name"
}
variable "zone_id" {
  type        = string
  description = "Route 53 zone id"
  default     = null
}
variable "encrypted" {
  type        = bool
  description = "Encryption of volumes"
  default     = true
}
# ---------------------------
# ALB Vars
# ---------------------------
variable "subnets" {
  type        = list(string)
  description = "Subnets where the ALB will be placed"
}
variable "enable_deletion_protection" {
  type        = bool
  description = "Enable / Disable deletion protection for the ALB."
  default     = false
}
variable "enable_cross_zone_load_balancing" {
  type        = bool
  description = "Enable / Disable cross zone load balancing"
  default     = false
}
variable "internal" {
  type        = bool
  description = "Is the ALB internal?"
  default     = false
}
variable "http_listener_required" {
  type        = bool
  description = "Enables / Disables creating HTTP listener. Listener auto redirects to HTTPS"
  default     = true
}
variable "listener1_alb_listener_port" {
  type        = number
  description = "HTTP listener port"
  default     = 80
}
variable "listener1_alb_listener_protocol" {
  type        = string
  description = "HTTP listener protocol"
  default     = "HTTP"
}
# Listener port and protocol need to match
variable "alb_listener_port" {
  type        = number
  description = "ALB listener port"
  default     = "443"
}
variable "alb_listener_protocol" {
  type        = string
  description = "ALB listener protocol"
  default     = "HTTPS"
}
variable "healthy_threshold" {
  type        = number
  description = "ALB healthy count"
  default     = 2
}
variable "unhealthy_threshold" {
  type        = number
  description = "ALB unhealthy count"
  default     = 10
}
variable "timeout" {
  type        = number
  description = "ALB timeout value"
  default     = 5
}
variable "interval" {
  type        = number
  description = "ALB health check interval"
  default     = 20
}
variable "svc_port" {
  type        = number
  description = "Service port: The port on which targets receive traffic."
  default     = 8080
}
variable "target_group_path" {
  type        = string
  description = "Health check request path"
  default     = "/"
}
variable "target_group_protocol" {
  type        = string
  description = "The protocol to use to connect to the target"
  default     = "HTTP"
}
variable "target_group_port" {
  type        = number
  description = "The port to use to connect with the target"
  default     = "8080"
}
variable "drop_invalid_header_fields" {
  type        = bool
  description = "Whether HTTP headers with header fields that are not valid are removed by the load balancer"
  default     = true
}
# ---------------------------
# EFS Vars
# ---------------------------
variable "efs_encrypted" {
  type        = bool
  description = "Encrypt the EFS share"
  default     = true
}
variable "deletion_window_in_days" {
  type        = number
  description = "Number of days before permanent removal"
  default     = "30"
}
variable "enable_key_rotation" {
  type        = bool
  description = "KMS key rotation"
  default     = true
}
variable "performance_mode" {
  type        = string
  description = "EFS performance mode.https://docs.aws.amazon.com/efs/latest/ug/performance.html"
  default     = "generalPurpose"
}
variable "private_subnet_a" {
  type        = string
  description = "1st private subnet id"
}
variable "private_subnet_b" {
  type        = string
  description = "2nd private subnet id"
}
variable "security_groups_mount_target_a" {
  type        = list(string)
  description = "Security groups to use for mount target subnet a. Create outside of module and pass in"
}
variable "security_groups_mount_target_b" {
  type        = list(string)
  description = "Security groups to use for mount target subnet b. Create outside of module and pass in"
}
# ---------------------------
# ASG & LC Vars
# ---------------------------
variable "max_size" {
  type        = number
  description = "AutoScaling Group max size"
  default     = 1
}
variable "min_size" {
  type        = number
  description = "AutoScaling Group min size"
  default     = 1
}
variable "desired_capacity" {
  type        = number
  description = "AutoScaling Group desired capacity"
  default     = 1
}
variable "vpc_zone_identifier" {
  type        = list(string)
  description = "A list of subnet IDs to launch AutoScaling resources in."
}
variable "enable_monitoring" {
  type        = bool
  description = "AutoScaling - enables/disables detailed monitoring"
  default     = "false"
}
variable "health_check_grace_period" {
  type        = number
  description = "AutoScaling health check grace period"
  default     = 180
}
variable "health_check_type" {
  type        = string
  description = "AutoScaling health check type. EC2 or ELB"
  default     = "ELB"
}
variable "volume_type" {
  type        = string
  description = "ec2 volume type"
  default     = "gp2"
}
variable "volume_size" {
  type        = number
  description = "ec2 volume size"
  default     = 30
}
variable "scale_up_cron" {
  type        = string
  description = "The time when the recurring scale up action start.Cron format"
  default     = "30 0 * * SUN"
}
variable "scale_down_cron" {
  type        = string
  description = "The time when the recurring scale down action start.Cron format"
  default     = "0 0 * * SUN"
}
