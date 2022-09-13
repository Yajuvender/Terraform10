
data "aws_route53_zone" "mydomain" {
  name = "yajuenterprise.quest"
}

output "mydomain_zoneid" {
  description = "Hosted Zone id of the desired Hosted Zone"
  value       = data.aws_route53_zone.mydomain.zone_id

}

output "mydomain_name" {
  description = "Hosted Zone Name of the desired Hosted Zone"
  value       = data.aws_route53_zone.mydomain.name

}