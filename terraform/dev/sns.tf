resource "aws_sns_topic" "sns" {
  name = "${var.project_name}-sns-topic"
}