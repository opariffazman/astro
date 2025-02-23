locals {
  app_port = 8080
  app_name = "app"
  web_port = 8080
  web_name = "web"
}

module "app_asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "8.1.0"

  name                    = "${var.project_name}-app-asg"

  create_launch_template = false
  launch_template_id      = aws_launch_template.app.id

  min_size         = 0
  max_size         = 1
  desired_capacity = 1

  wait_for_capacity_timeout = 0
  health_check_type         = "ELB"
  vpc_zone_identifier       = module.vpc.private_subnets

  traffic_source_attachments = {
    app-alb = {
      traffic_source_identifier = module.app_alb.target_groups["app-asg"].arn
      traffic_source_type       = "elbv2"
    }
  }

  tags = var.tags
}

module "web_asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "8.1.0"

  name                    = "${var.project_name}-web-asg"

  create_launch_template = false
  launch_template_id      = aws_launch_template.web.id

  min_size         = 0
  max_size         = 1
  desired_capacity = 1

  wait_for_capacity_timeout = 0
  health_check_type         = "ELB"
  vpc_zone_identifier       = module.vpc.public_subnets

  traffic_source_attachments = {
    web-alb = {
      traffic_source_identifier = module.web_alb.target_groups["web-asg"].arn
      traffic_source_type       = "elbv2"
    }
  }

  tags = var.tags
}
