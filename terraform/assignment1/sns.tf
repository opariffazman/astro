resource "aws_sns_topic" "sns" {
  name = "${local.project_name}-sns-topic"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.sns.arn
  protocol  = "email"
  endpoint  = local.email_address
}