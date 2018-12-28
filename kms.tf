# -------------------------------------------------------
# KMS Key for EFS
# -------------------------------------------------------
resource "aws_kms_key" "efskey" {
  description             = "This key is used to encrypt EFS, used by Jenkins, in ${var.environment}"
  deletion_window_in_days = 30
}

# Create KMS Alias

resource "aws_kms_alias" "efs" {
  name          = "alias/efs-jenkins-${var.environment}"
  target_key_id = "${aws_kms_key.efskey.key_id}"
}
