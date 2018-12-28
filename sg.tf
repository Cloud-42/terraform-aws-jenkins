# --------------------------
# ec2 ssh Security Group
# --------------------------
resource "aws_security_group" "ec2_ssh_sg" {
  name        = "${var.environment}.ec2.jenkins.ssh.sg"
  description = "Security group for controlling ssh access to Jenkins server."
  vpc_id      = "${var.vpc_id}"

  # Allow ssh from given CIDR ranges
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "TCP"
    security_groups = ["${var.trusted_security_groups}"]
  }

  # Allow all outbound traffic

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    "environment"   = "${var.environment}"
    "contact"       = "${var.contact}"
    "orchestration" = "${var.orchestration}"
  }
}

# --------------------------
# ec2 access Security Group
# --------------------------
resource "aws_security_group" "ec2_sg" {
  name        = "${var.environment}.ec2.jenkins.access.sg"
  description = "Security group for controlling access to the Jenkins instance."
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "TCP"
    security_groups = ["${aws_security_group.alb_sg.id}"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    "Environment"   = "${var.environment}"
    "Contact"       = "${var.contact}"
    "Orchestration" = "${var.orchestration}"
  }
}

# --------------------------
# ALB Security Group
# --------------------------
resource "aws_security_group" "alb_sg" {
  name        = "${var.environment}.jenkins.alb.sg"
  description = "Security group for controlling access to the Jenkins ALB."
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.access_from)}"]
  }

  tags {
    "environment"   = "${var.environment}"
    "contact"       = "${var.contact}"
    "orchestration" = "${var.orchestration}"
  }
}

# --------------------------
# +1 rule to allow ALB - to - ec2 on 8080
# --------------------------
resource "aws_security_group_rule" "alb_to_ec2" {
  type      = "egress"
  from_port = 8080
  to_port   = 8080
  protocol  = "TCP"

  source_security_group_id = "${aws_security_group.ec2_sg.id}"
  security_group_id        = "${aws_security_group.alb_sg.id}"
}

# --------------------------
# EFS Security Groups
# --------------------------
resource "aws_security_group" "private_subnet_a" {
  count       = "${var.private_subnet_b != "" ? 1 : 0}"
  name        = "${var.environment}.efs.subnet.a.sg"
  description = "Security group for controlling access to EFS from subnet A"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["${var.subnet_a_ip_range}"]
  }

  tags {
    "environment"   = "${var.environment}"
    "contact"       = "${var.contact}"
    "orchestration" = "${var.orchestration}"
  }
}

resource "aws_security_group" "private_subnet_b" {
  count       = "${var.private_subnet_b != "" ? 1 : 0}"
  name        = "${var.environment}.efs.subnet.b.sg"
  description = "Security group for controlling access to EFS from subnet B"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["${var.subnet_b_ip_range}"]
  }

  tags {
    "environment"   = "${var.environment}"
    "contact"       = "${var.contact}"
    "orchestration" = "${var.orchestration}"
  }
}
