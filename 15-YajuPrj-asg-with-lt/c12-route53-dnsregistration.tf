
resource "aws_route53_record" "mydnsrecord" {
  zone_id = data.aws_route53_zone.myroute53zone.zone_id
  name    = "asg-lt.yajuenterprise.quest"
  type    = "A"

  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = true
  }
}
