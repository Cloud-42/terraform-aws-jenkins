# --------------------------
# IAM Role & IAM Profile
# --------------------------
resource "aws_iam_instance_profile" "ec2_profile" {
  depends_on = ["aws_iam_role.ec2_role"]
  name       = "ec2.jenkins.ec2-profile.${var.environment}"
  role       = "${aws_iam_role.ec2_role.name}"
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2.jenkins.ec2-role.${var.environment}"
  path = "/"

  assume_role_policy = <<EOF
{"Version": "2012-10-17",
"Statement": [
{
"Action": "sts:AssumeRole",
"Principal": {
"Service": "ec2.amazonaws.com"
},
"Effect": "Allow",
"Sid": ""
}
]
}
EOF
}

# --------------------------
# STD ec2 policy
# --------------------------

resource "aws_iam_role_policy" "ec2_policy" {
  depends_on = ["aws_iam_role.ec2_role"]
  name       = "ec2.jenkins.${var.environment}.std.s3"
  role       = "${aws_iam_role.ec2_role.id}"

  policy = <<EOF
{"Version": "2012-10-17",
"Statement": [
{
"Effect": "Allow",
"Action": [
"s3:GetBucketLocation",
"s3:ListAllMyBuckets",
"s3:ListBucket"
],
"Resource": [
"arn:aws:s3:::*"
]
},
{
"Effect": "Allow",
"Action": [
"s3:*"
],
"Resource": [
"${aws_s3_bucket.s3.arn}/*"
]
}
]
}
EOF
}
