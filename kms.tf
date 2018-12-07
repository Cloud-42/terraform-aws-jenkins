# --------------------------
# Create KMS key to avoid using default key
# --------------------------
resource "aws_kms_key" "key" {
  description             = "This key is used to encrypt the s3 bucket, used by the Jenkins Master in ${var.environment}"
  deletion_window_in_days = 30
}

# --------------------------
# Create KMS Alias
# --------------------------

resource "aws_kms_alias" "a" {
  name          = "alias/jenkins-${var.environment}-s3-data"
  target_key_id = "${aws_kms_key.key.key_id}"
}

# --------------------------
# KMS Key for EFS
# --------------------------

resource "aws_kms_key" "efskey" {
  description             = "This key is used to encrypt EFS, used by the Jenkins Master in ${var.environment}"
  deletion_window_in_days = 30
}

# --------------------------
# Create KMS Alias
# --------------------------

resource "aws_kms_alias" "efs" {
  name          = "alias/efs-${var.environment}"
  target_key_id = "${aws_kms_key.efskey.key_id}"
}
