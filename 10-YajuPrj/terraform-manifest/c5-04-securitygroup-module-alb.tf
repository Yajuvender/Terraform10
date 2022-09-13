
module "alb-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.13.0"

  name = "${local.name}-alb-sg"

  vpc_id = module.vpc.vpc_id

  // List of rule names are listed in https://github.com/terraform-aws-modules/terraform-aws-security-group/blob/master/rules.tf
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]

  egress_rules = ["all-all"]

  tags = local.common_tags
}

