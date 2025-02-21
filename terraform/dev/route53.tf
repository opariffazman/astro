module "route53_zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "4.1.0"

  zones = {
    "astro.opariffazman.com" = {
      comment = "Private hosted zone for ${var.project_name} applications"
      tags    = var.tags
      vpc = [{
        vpc_id = module.vpc.vpc_id
      }]
    }
  }

  tags = var.tags
}

module "route53_records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "4.1.0"

  zone_id = module.route53_zones.route53_zone_zone_id["astro.opariffazman.com"]

  records = [
    {
      name = "app"
      type = "A"
      alias = {
        name    = module.app_alb.dns_name
        zone_id = module.app_alb.zone_id
      }
    },
    {
      name    = "db"
      type    = "CNAME"
      records = [module.rds.db_instance_address]
    }
  ]

  depends_on = [module.route53_zones]
}

output "route53_nameservers" {
  description = "Nameservers for the hosted zone"
  value       = module.route53_zones.route53_zone_name_servers
}