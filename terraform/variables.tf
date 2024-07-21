variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "lambda_s3_bucket" {
  description = "air-lambda-project"
  type        = string
}

variable "lambda_s3_key" {
  description = "function.zip"
  type        = string
}