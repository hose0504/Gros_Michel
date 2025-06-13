resource "aws_route53_zone" "main" {
  name = var.domain_name
}

# 루트 도메인: grosmichel.click
resource "aws_route53_record" "root_geo" {
  count           = length(var.regions)
  zone_id         = aws_route53_zone.main.zone_id
  name            = var.domain_name
  type            = "A"
  set_identifier  = "root-${var.regions[count.index].name}"

alias {
  name    = var.alb_dns_name          
  zone_id = var.alb_zone_id           
  evaluate_target_health = false
}

  geolocation_routing_policy {
    country = var.regions[count.index].location  # 예: "KR", "US", "JP", "default"
  }
}

# www 서브도메인: www.grosmichel.click
resource "aws_route53_record" "www_geo" {
  count           = length(var.regions)
  zone_id         = aws_route53_zone.main.zone_id
  name            = "www.${var.domain_name}"
  type            = "A"
  set_identifier  = "www-${var.regions[count.index].name}"

alias {
  name    = var.alb_dns_name          
  zone_id = var.alb_zone_id           
  evaluate_target_health = false
}

  geolocation_routing_policy {
    country = var.regions[count.index].location
  }
}
