resource "aws_sns_topic" "lambda_failure_topic" {
  name = "etl-lambda-failure-topic"

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.lambda_failure_topic.arn
  protocol  = "email"
  endpoint  = var.alert_email

#   lifecycle {
#     prevent_destroy = true
#     ignore_changes  = all
#   }
}


resource "aws_cloudwatch_metric_alarm" "lambda_error_alarm" {
  alarm_name = "etl-lambda-error-alarm"
  #   alarm_description = "Triggered when ETL Lambda errors occur"

  namespace   = "AWS/Lambda"
  metric_name = "Errors"
  statistic   = "Sum"

  period              = 60
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"

  #   dimensions = {
  #     FunctionName = aws_lambda_function.etl_lambda.function_name
  #   }

  alarm_actions = [
    aws_sns_topic.lambda_failure_topic.arn
  ]

  #   ok_actions                = []
  #   insufficient_data_actions = []

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/etl_automation_lambda_sales"
  retention_in_days = 14
}