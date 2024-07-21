provider "aws" {
  region = var.aws_region
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "lambda_s3_read_policy" {
  name        = "lambda_s3_read_policy"
  description = "IAM policy for reading objects from S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
        ],
        Effect   = "Allow",
        Resource = [
          "arn:aws:s3:::${var.lambda_s3_bucket}/*",
        ],
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "lambda_s3_read_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_s3_read_policy.arn
}



resource "aws_lambda_function" "incident_response" {
  function_name = "incidentResponseFunction"

  s3_bucket = var.lambda_s3_bucket
  s3_key    = var.lambda_s3_key

  handler = "index.handler"
  runtime = "nodejs14.x"
  role    = aws_iam_role.lambda_execution_role.arn
}

resource "aws_sns_topic" "incident_alerts" {
  name = "incident-alerts"
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

