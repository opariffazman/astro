module "app_iam_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.52.2"

  create_role             = true
  create_instance_profile = true
  role_name               = "${local.project_name}-app-role"

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonRDSFullAccess",
    "arn:aws:iam::aws:policy/CloudWatchFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  trusted_role_services = ["ec2.amazonaws.com"]
}

module "web_iam_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.52.2"

  create_role             = true
  create_instance_profile = true
  role_name               = "${local.project_name}-web-role"

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  trusted_role_services = ["ec2.amazonaws.com"]
}