
resource "aws_route53_record" "mydnsrecord" {
  zone_id = data.aws_route53_zone.myroute53zone.zone_id
  name    = "apps.yajuenterprise.quest"
  type    = "A"

  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = true
  }
}


resource "aws_route53_record" "app1dnsrecord" {
  zone_id = data.aws_route53_zone.myroute53zone.zone_id
  name    = var.app1_dns_name
  type    = "A"

  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "app2dnsrecord" {
  zone_id = data.aws_route53_zone.myroute53zone.zone_id
  name    = var.app2_dns_name
  type    = "A"

  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = true
  }
}

