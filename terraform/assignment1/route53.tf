resource "aws_route53_zone" "private" {
  name = local.zone_name

  vpc {
    vpc_id = module.vpc.vpc_id
  }

  tags = local.tags
}

resource "aws_route53_record" "app" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "app.${local.zone_name}"
  type    = "A"

  alias {
    name                   = module.app_alb.dns_name
    zone_id                = module.app_alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "db" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "db.${local.zone_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [module.rds.db_instance_address]
}
