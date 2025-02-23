resource "aws_launch_template" "app" {
  name = "${var.project_name}-app-lt"

  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.nano"

  iam_instance_profile {
    name = module.app_iam_role.iam_instance_profile_id
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [module.app_security_group.security_group_id]
  }

  user_data = base64encode(templatefile("../../scripts/bash/userdata.sh", {
    TIER_PORT = 8080
    TIER_NAME = "app"
  }))

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }
}

resource "aws_launch_template" "web" {
  name = "${var.project_name}-web-lt"

  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.nano"

  iam_instance_profile {
    name = module.web_iam_role.iam_instance_profile_id
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [module.web_security_group.security_group_id]
  }

  user_data = base64encode(templatefile("../../scripts/bash/userdata.sh", {
    TIER_PORT = 8080
    TIER_NAME = "web"
  }))

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }
}
