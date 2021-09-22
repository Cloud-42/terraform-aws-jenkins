# -----------------------
# Jenkins 
# -----------------------
module "jenkins" {
  depends_on = [module.jenkins-efs-sg,
    module.jenkins-alb-sg
  ]

  source  = "Cloud-42/jenkins/aws"
  version = "5.2.0"
  
  instance_type        = "t3a.medium"
  iam_instance_profile = module.jenkins-role.profile.name
  key_name             = var.env
  environment          = var.env
  zone_id              = aws_route53_zone.prd.zone_id
  vpc_id               = module.vpc.vpc_id
  domain_name          = aws_route53_zone.prd.name
  ami                  = data.aws_ami.latest_amazon_linux_ami.id
  certificate_arn      = module.acm.this_acm_certificate_arn
  target_group_path    = "/login"
  tags                 = var.tags
  asg_tags = [{
    key                 = "Name"
    value               = "jenkins"
    propagate_at_launch = true
    },
    {
      key                 = "ManagedBy"
      value               = "Terraform"
      propagate_at_launch = true
    },
    {
      key                 = "env"
      value               = var.env
      propagate_at_launch = true
    }
  ]
  #
  # Security Groups
  #
  security_groups                = [module.jenkins-ec2-sg.this_security_group_id]
  security_groups_alb            = [module.jenkins-alb-sg.this_security_group_id]
  security_groups_mount_target_a = [module.jenkins-efs-sg.this_security_group_id]
  security_groups_mount_target_b = [module.jenkins-efs-sg.this_security_group_id]
  #
  # subnet assignments
  #
  private_subnet_a    = module.vpc.private_subnets[0]
  private_subnet_b    = module.vpc.private_subnets[1]
  subnets             = module.vpc.public_subnets
  vpc_zone_identifier = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
}
# -----------------------------
# Security Groups
# ------------------------------
module "jenkins-efs-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.17.0"

  name        = "jenkins-efs-sg"
  description = "Security group for Jenkins EFS"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]
  ingress_rules       = ["nfs-tcp"]
  egress_rules        = ["all-all"]
}
module "jenkins-alb-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.17.0"

  name        = "jenkins-alb-sg"
  description = "Security group for access to Jenkins endpoint"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  egress_rules        = ["all-all"]
}
module "jenkins-ec2-sg" {
  depends_on = [module.jenkins-alb-sg]
  source     = "terraform-aws-modules/security-group/aws"
  version    = "3.17.0"

  name        = "jenkins-sg"
  description = "Security group for Jenkins host"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 8080
      to_port                  = 8080
      protocol                 = 6
      description              = "Jenkins ALB"
      source_security_group_id = module.jenkins-alb-sg.this_security_group_id
    },
  ]

  egress_rules = ["all-all"]
}
# -----------------------
# Role for Jenkins to use
# -----------------------
module "jenkins-role" {
  source  = "Cloud-42/ec2-iam-role/aws"
  version = "3.0.0"

  name = "jenkins"

  policy_arn = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
  ]
}
# -----------------------
# VPC
# -----------------------
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.65.0"

  name = var.env
  cidr = "172.18.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["172.18.0.0/19", "172.18.32.0/19", "172.18.64.0/19"]
  public_subnets  = ["172.18.128.0/19", "172.18.160.0/19", "172.18.192.0/19"]

  enable_nat_gateway       = true
  enable_dns_hostnames     = true
  tags                     = var.tags
}
