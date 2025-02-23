locals {
  app_port = 8080
  app_name = "app"
  web_port = 8080
  web_name = "web"
}

resource "aws_launch_template" "app" {
  name                   = "${var.project_name}-app-lt"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  update_default_version = true

  iam_instance_profile {
    arn = module.app_iam_role.iam_instance_profile_arn
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [module.app_security_group.security_group_id]
  }

  user_data = base64encode(templatefile("../../scripts/bash/userdata.sh", {
    TIER_PORT = local.app_port
    TIER_NAME = local.app_name
  }))

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }
}

resource "aws_launch_template" "web" {
  name                   = "${var.project_name}-web-lt"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  update_default_version = true

  iam_instance_profile {
    arn = module.web_iam_role.iam_instance_profile_arn
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [module.web_security_group.security_group_id]
  }

  user_data = base64encode(templatefile("../../scripts/bash/userdata.sh", {
    TIER_PORT = local.web_port
    TIER_NAME = local.web_name
  }))

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }
}
