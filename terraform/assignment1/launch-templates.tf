resource "aws_launch_template" "app" {
  name                   = "${local.project_name}-app-lt"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  update_default_version = true

  iam_instance_profile {
    name = module.app_iam_role.iam_instance_profile_name
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
    tags          = local.tags
  }
}

resource "aws_launch_template" "web" {
  name                   = "${local.project_name}-web-lt"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  update_default_version = true

  iam_instance_profile {
    name = module.web_iam_role.iam_instance_profile_name
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
    tags          = local.tags
  }
}
