module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "4.1.0"

  domain_name = data.aws_route53_zone.myroute53zone.name    //"my-domain.com"
  zone_id     = data.aws_route53_zone.myroute53zone.zone_id //"Z2ES7B9AZ6SHAE"

  subject_alternative_names = [
    "*.${data.aws_route53_zone.myroute53zone.name}",

  ]

  tags = local.common_tags
}

 