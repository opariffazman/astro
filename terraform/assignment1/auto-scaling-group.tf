resource "aws_autoscaling_group" "app" {
  name                = "${var.project_name}-web-asg"
  vpc_zone_identifier = module.vpc.private_subnets
  desired_capacity    = 1
  max_size            = 1
  min_size            = 0

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_group" "web" {
  name                = "${var.project_name}-web-asg"
  vpc_zone_identifier = module.vpc.public_subnets
  desired_capacity    = 0
  max_size            = 1
  min_size            = 0

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
}
