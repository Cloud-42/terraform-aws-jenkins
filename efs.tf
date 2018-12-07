# --------------------------
# EFS FileSystem
# --------------------------
resource "aws_efs_file_system" "this" {
  depends_on = ["aws_kms_key.efskey"]
  depends_on = ["aws_security_group.private_subnet_a"]
  depends_on = ["aws_security_group.private_subnet_b"]

  encrypted        = "${var.efs_encrypted}"
  performance_mode = "${var.performance_mode}"
  kms_key_id       = "${aws_kms_key.efskey.arn}"

  tags {
    Name            = "${var.environment}_jenkins_ec2"
    "Environment"   = "${var.environment}"
    "Orchestration" = "${var.orchestration}"
  }
}

# --------------------------
# Mount points
# --------------------------
resource "aws_efs_mount_target" "private_subnet_a" {
  depends_on      = ["aws_efs_file_system.this"]
  count           = "${var.private_subnet_b != "" ? 1 : 0}"
  file_system_id  = "${aws_efs_file_system.this.id}"
  security_groups = ["${aws_security_group.private_subnet_a.id}"]
  subnet_id       = "${var.private_subnet_a}"
}

resource "aws_efs_mount_target" "private_subnet_b" {
  depends_on      = ["aws_efs_file_system.this"]
  count           = "${var.private_subnet_b != "" ? 1 : 0}"
  file_system_id  = "${aws_efs_file_system.this.id}"
  security_groups = ["${aws_security_group.private_subnet_b.id}"]
  subnet_id       = "${var.private_subnet_b}"
}
