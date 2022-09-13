
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.4"

  name = "${local.name}-${var.vpc_name}"
  cidr = var.vpc_cidr_block

  azs              = var.vpc_availability_zones
  private_subnets  = var.vpc_private_subnets
  public_subnets   = var.vpc_public_subnets
  database_subnets = var.vpc_database_subnets

  create_database_subnet_group = true

  manage_default_route_table = true
  default_route_table_tags   = { Name = "${local.name}-default" }

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.common_tags

}

