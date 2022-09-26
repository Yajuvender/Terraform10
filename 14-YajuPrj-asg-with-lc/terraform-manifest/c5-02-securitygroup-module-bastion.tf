module "bastion-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.13.0"

  name = "${local.name}-bastion-sg"

  description = "Security group which is used as an argument in bastion-sg"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]

  // intentionally gave https and http to test the ec2 directly.. ideally only SSH should be open for bastion
  ingress_rules = ["ssh-tcp", "https-443-tcp", "http-80-tcp"]

  egress_rules = ["all-all"]

  tags = local.common_tags
}