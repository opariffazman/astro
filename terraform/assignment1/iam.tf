resource "aws_iam_role" "app" {
  name = "app-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "app" {
  for_each = toset(local.app_policies)

  role       = aws_iam_role.app.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "app" {
  name = "app-iam-instance-profile"
  role = aws_iam_role.app.name
}

resource "aws_iam_role" "web" {
  name = "web-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "web" {
  for_each = toset(local.web_policies)

  role       = aws_iam_role.web.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "web" {
  name = "web-iam-instance-profile"
  role = aws_iam_role.web.name
}