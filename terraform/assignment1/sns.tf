resource "aws_sns_topic" "sns" {
  name = "${local.project_name}-sns-topic"
}