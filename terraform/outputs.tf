output "lambda_function_name" {
  value = aws_lambda_function.incident_response.function_name
}

output "sns_topic_arn" {
  value = aws_sns_topic.incident_alerts.arn
}