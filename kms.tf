# -------------------------------------------------------
# KMS Key for EFS
# -------------------------------------------------------
resource "aws_kms_key" "efskey" {
  description             = "This key is used to encrypt EFS, used by Jenkins, in ${var.environment}"
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation
}

# Create KMS Alias

resource "aws_kms_alias" "efs" {
  name          = "alias/efs-jenkins-${var.environment}"
  target_key_id = aws_kms_key.efskey.key_id
}

