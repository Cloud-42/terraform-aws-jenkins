# ---------------------------------------------------
# Find latest Amazon Linux AMI
# ---------------------------------------------------
data "aws_ami" "latest_amazon_linux_ami" {
  most_recent = true

  #
  # 137112412989 - AWS
  # Beware of using anything other than this
  #
  owners = ["137112412989"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
}
