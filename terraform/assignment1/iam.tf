module "app_iam_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.52.2"

  create_role = true
  role_name   = "${var.project_name}-app-role"

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonRDSFullAccess",
    "arn:aws:iam::aws:policy/CloudWatchFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ]

  trusted_role_services = ["ec2.amazonaws.com"]
}
