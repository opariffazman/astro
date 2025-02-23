resource "aws_autoscaling_group" "app" {
  name                = "${local.project_name}-app-asg"
  force_delete        = true
  vpc_zone_identifier = module.vpc.private_subnets
  desired_capacity    = 1
  max_size            = 1
  min_size            = 0

  launch_template {
    id      = aws_launch_template.app.id
    version = aws_launch_template.app.latest_version
  }

  tag {
    key                 = "Name"
    value               = "${local.project_name}-app"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  target_group_arns = [module.app_alb.target_groups["app-asg"].arn]
}

resource "aws_autoscaling_group" "web" {
  name                = "${local.project_name}-web-asg"
  force_delete        = true
  vpc_zone_identifier = module.vpc.public_subnets
  desired_capacity    = 0
  max_size            = 1
  min_size            = 0

  launch_template {
    id      = aws_launch_template.web.id
    version = aws_launch_template.web.latest_version
  }

  tag {
    key                 = "Name"
    value               = "${local.project_name}-web"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  target_group_arns = [module.web_alb.target_groups["web-asg"].arn]
}
