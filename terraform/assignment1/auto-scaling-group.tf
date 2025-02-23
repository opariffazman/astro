module "app_asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "8.1.0"

  name = "${local.project_name}-app-asg"

  vpc_zone_identifier = module.vpc.private_subnets
  security_groups     = [module.app_security_group.security_group_id]
  min_size            = 0
  max_size            = 1
  desired_capacity    = 0

  iam_instance_profile_arn = module.app_iam_role.iam_instance_profile_arn

  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  ignore_desired_capacity_changes = true

  user_data = base64encode(templatefile("../../scripts/bash/userdata.sh", {
    TIER_PORT = local.app_port
    TIER_NAME = local.app_name
  }))
}

module "web_asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "8.1.0"

  name = "${local.project_name}-web-asg"

  vpc_zone_identifier = module.vpc.public_subnets
  security_groups     = [module.web_security_group.security_group_id]
  min_size            = 0
  max_size            = 1
  desired_capacity    = 1

  iam_instance_profile_arn = module.web_iam_role.iam_instance_profile_arn

  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  ignore_desired_capacity_changes = true

  user_data = base64encode(templatefile("../../scripts/bash/userdata.sh", {
    TIER_PORT = local.web_port
    TIER_NAME = local.web_name
  }))
}