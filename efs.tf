# --------------------------
# EFS FileSystem
# --------------------------
resource "aws_efs_file_system" "this" {
  depends_on = [aws_kms_key.efskey]

  encrypted        = var.efs_encrypted
  performance_mode = var.performance_mode
  kms_key_id       = aws_kms_key.efskey.arn

  tags = var.tags
}

# --------------------------
# Mount points
# --------------------------
resource "aws_efs_mount_target" "private_subnet_a" {
  depends_on      = [aws_efs_file_system.this]
  count           = var.private_subnet_b != "" ? 1 : 0
  file_system_id  = aws_efs_file_system.this.id
  security_groups = var.security_groups_mount_target_a
  subnet_id       = var.private_subnet_a
}

resource "aws_efs_mount_target" "private_subnet_b" {
  depends_on      = [aws_efs_file_system.this]
  count           = var.private_subnet_b != "" ? 1 : 0
  file_system_id  = aws_efs_file_system.this.id
  security_groups = var.security_groups_mount_target_b
  subnet_id       = var.private_subnet_b
}

