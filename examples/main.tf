#
# The module is usually called from a 
# top level "control" repository.
#
module "jenkins" {
  source  = "Cloud-42/jenkins/aws"
  version = "2.0.0"

  instance_type           = "t3a.medium"
  iam_instance_profile    = module.jenkins-cross-account-access.profile.name
  trusted_security_groups = module.bastion_sg.this_security_group_id
  private_subnets         = ["${element(split(",", module.vpc.subnets_private), 0)}", "${element(split(",", module.vpc.subnets_private), 1)}"]
  orchestration           = var.orchestration
  key_name                = var.key_name
  environment             = var.environment
  availability_zones      = var.availability_zones
  contact                 = var.contact
  zone_id                 = module.vpc.zone_id
  vpc_id                  = module.vpc.vpc_id
  domain_name             = var.dns_domain
  security_group_alb      = ["${module.jenkins_sg.this_security_group_id}"]
  vpc_zone_identifier     = ["${element(split(",", module.vpc.subnets_private), 0)}", "${element(split(",", module.vpc.subnets_private), 1)}"]
  ami                     = "${data.aws_ami.ubuntuserver_ami.id}"
  #
  # EFS Vars
  #
  private_subnet_a  = "${element(split(",", module.vpc.subnets_private), 0)}"
  private_subnet_b  = "${element(split(",", module.vpc.subnets_private), 1)}"
  subnet_a_ip_range = "${element(split(",", var.nonprd_private_subnets), 0)}"
  subnet_b_ip_range = "${element(split(",", var.nonprd_private_subnets), 1)}"
  #
  # ALB Vars
  #
  certificate_arn   = module.certificate.cert.id
  subnets           = module.vpc.subnets_public
  target_group_path = "/login"
}

# ---------------------
# SG for Jenkins ALB
# ---------------------
module "jenkins_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.1.0"

  name        = "jenkins_alb_sg"
  description = "Security group granting access to the Jenkins endpoint"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "TCP"
      description = "HTTP Access"
      cidr_blocks = var.office_ip
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "TCP"
      description = "HTTPS Access"
      cidr_blocks = var.office_ip
    },
  ]

  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

