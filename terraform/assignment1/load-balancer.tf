module "app_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.13.0"

  name    = "${local.project_name}-app-alb"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.private_subnets

  security_groups = [module.app_security_group.security_group_id]

  target_groups = {
    app-asg = {
      name             = "${local.project_name}-app-tg"
      backend_protocol = "HTTP"
      backend_port     = local.app_port
      target_type      = "instance"

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/health"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
      }

      create_attachment = false
    }
  }

  enable_deletion_protection = false

  tags = local.tags
}


module "web_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.13.0"

  name    = "${local.project_name}-web-alb"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  security_groups = [module.web_security_group.security_group_id]

  target_groups = {
    web-asg = {
      name             = "${local.project_name}-web-tg"
      backend_protocol = "HTTP"
      backend_port     = local.web_port
      target_type      = "instance"

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/health"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
      }

      create_attachment = false
    }
  }

  enable_deletion_protection = false

  tags = local.tags
}
