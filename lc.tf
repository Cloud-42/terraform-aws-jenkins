# --------------------------
# Launch Config
# --------------------------
resource "aws_launch_configuration" "jenkins" {
  name_prefix          = "terraform-jenkins-lc-"
  image_id             = var.ami
  instance_type        = var.instance_type
  key_name             = var.key_name
  iam_instance_profile = var.iam_instance_profile
  security_groups      = var.security_groups
  enable_monitoring    = var.enable_monitoring
  user_data = var.custom_userdata != "" ? var.custom_userdata : templatefile(
    "${path.module}/userdata.sh", {
      appliedhostname         = var.hostname_prefix
      domain_name             = var.domain_name
      environment             = var.environment
      efs_dnsname             = aws_efs_file_system.this.dns_name
      preliminary_user_data   = var.preliminary_user_data
      supplementary_user_data = var.supplementary_user_data
  })

  # Setup root block device
  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
    encrypted   = var.encrypted
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  # Create before destroy
  lifecycle {
    create_before_destroy = true
  }
}

