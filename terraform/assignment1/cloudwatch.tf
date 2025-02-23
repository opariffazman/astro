resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "${local.project_name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors EC2 CPU utilization"
  alarm_actions       = [aws_sns_topic.sns.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }
}