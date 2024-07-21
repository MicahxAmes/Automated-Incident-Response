provider "aws" {
  region = "us-east-2"
}

resource "aws_lambda_function" "incident_response" {
  function_name = "incidentResponseFunction"

  s3_bucket = "lambda-airp"  
  s3_key    = "function.zip"   

  handler = "index.handler"
  runtime = "nodejs18.x"
  role    = "arn:aws:iam::339712707581:role/LambdaController" 
}

resource "aws_sns_topic" "incident_alerts" {
  name     = "incident-alerts"
}

resource "aws_lambda_permission" "sns_invoke" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.incident_response.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.incident_alerts.arn
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.incident_response.function_name}"
  retention_in_days = 30
}

