# --------------------------
# Launch Config
# --------------------------
resource "aws_launch_configuration" "jenkins" {
  name_prefix          = "terraform-jenkins-lc-"
  image_id             = "${var.ami}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.ec2_profile.name}"
  security_groups      = ["${aws_security_group.ec2_ssh_sg.id}", "${aws_security_group.ec2_sg.id}"]
  enable_monitoring    = "${var.enable_monitoring}"
  user_data            = "${data.template_file.user_data.rendered}"

  # Setup root block device
  root_block_device {
    volume_size = "${var.volume_size}"
    volume_type = "${var.volume_type}"
  }

  # Create before destroy
  lifecycle {
    create_before_destroy = true
  }
}

# --------------------------
# Render userdata bootstrap file
# --------------------------
data "template_file" "user_data" {
  template = "${file("${path.module}/userdata.sh")}"

  vars {
    appliedhostname = "${var.hostname_prefix}${format("%03d", count.index + 1 + var.hostname_offset)}"
    domain_name     = "${var.domain_name}"
    environment     = "${var.environment}"
    efs_dnsname     = "${aws_efs_file_system.this.dns_name}"
  }
}
