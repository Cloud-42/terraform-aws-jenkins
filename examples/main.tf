#
# The module is usually called from a 
# top level "control" repository.
#
module "jenkins" {
  source = "git::https://github.com/Cloud-42/terraform-aws-jenkins.git"

  instance_type           = "t2.medium"
  trusted_security_groups = "sg-12345xy"
  private_subnets         = "subnet-xxyyz,subnet-12345"
  orchestration           = "https://github.com/Cloud-42/terraform-aws-jenkins.git"
  key_name                = "${var.key_name}"
  environment             = "prod"
  availability_zones      = "${var.availability_zones}"
  contact                 = "contact@domain.io"
  zone_id                 = "${module.vpc.zone_id}"
  vpc_id                  = "${module.vpc.vpc_id}"
  domain_name             = "${var.dns_domain}"
  vpc_zone_identifier     = "${element(split(",",module.vpc.subnets_private),1)}"
  ami                     = "${data.aws_ami.ubuntuserver_ami.id}"

  #
  # EFS Vars
  #
  private_subnet_a = "subnet-xxyyz"

  private_subnet_b  = "subnet-12345"
  subnet_a_ip_range = "10.2.0.0/25"
  subnet_b_ip_range = "10.2.0.128/25"

  #
  # ALB Vars
  #
  certificate_arn = "arn:aws:acm:us-east-1:1234567891:certificate/161897e5-15aw-43sw-1523-51b0f92d2b3a"

  subnets           = "${module.vpc.subnets_public}"
  target_group_path = "/login"
}
