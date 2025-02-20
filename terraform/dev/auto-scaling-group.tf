module "app_asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "8.1.0"

  name = "${var.project_name}-app-asg"

  min_size         = 0
  max_size         = 1
  desired_capacity = 1

  wait_for_capacity_timeout = 0
  health_check_type         = "ELB"
  vpc_zone_identifier       = module.vpc.private_subnets

  instance_type = "t2.micro"
  image_id      = data.aws_ami.ubuntu.id
  user_data     = base64encode(file("../../scripts/bash/app-userdata.sh"))

  create_launch_template = true
  launch_template_name   = "${var.project_name}-app-launch-template"

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      min_healthy_percentage = 50
    }
  }

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

  name = "${var.project_name}-web-asg"

  min_size         = 0
  max_size         = 1
  desired_capacity = 1

  wait_for_capacity_timeout = 0
  health_check_type         = "ELB"
  vpc_zone_identifier       = module.vpc.public_subnets

  instance_type = "t2.micro"
  image_id      = data.aws_ami.ubuntu.id
  user_data     = base64encode(file("../../scripts/bash/web-userdata.sh"))

  create_launch_template = true
  launch_template_name   = "${var.project_name}-web-launch-template"

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      min_healthy_percentage = 50
    }
  }

  traffic_source_attachments = {
    app-alb = {
      traffic_source_identifier = module.web_alb.target_groups["web-asg"].arn
      traffic_source_type       = "elbv2"
    }
  }

  tags = var.tags
}
