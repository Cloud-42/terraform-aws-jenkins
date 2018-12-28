# ----------------------------
# S3 bucket
# ----------------------------

resource "aws_s3_bucket" "s3" {
  count  = "${var.test_data_bucket_enable ? 1 : 0}"
  bucket = "${var.environment}-jenkins-data"
  acl    = "private"

  tags {
    Name          = "${var.environment}-jenkins-data"
    environment   = "${var.environment}"
    orchestration = "${var.orchestration}"
    contact       = "${var.contact}"
  }
}
