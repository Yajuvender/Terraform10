
module "private-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.13.0"
 
  name        = "${local.name}-private-sg"
  description = "Security Group with HTTP & SSH port open for entire VPC Block (IPv4 CIDR)"
  vpc_id      = module.vpc.vpc_id

  // List of rule names are listed in https://github.com/terraform-aws-modules/terraform-aws-security-group/blob/master/rules.tf
  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]
  ingress_rules = ["ssh-tcp", "https-443-tcp", "http-80-tcp"]
   
  egress_rules = ["all-all"] 
  
  tags = local.common_tags
}
