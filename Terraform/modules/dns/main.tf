resource "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_route53_record" "www_records" {
  count          = length(var.regions)
  zone_id        = aws_route53_zone.main.zone_id
  name           = "www.${var.domain_name}"
  type           = "A"
  set_identifier = var.regions[count.index].name

  alias {
    name                   = var.regions[count.index].cdn_domain
    zone_id                = var.regions[count.index].cdn_zone_id
    evaluate_target_health = true
  }

  latency_routing_policy {
    region = var.regions[count.index].aws_region
  }
}
