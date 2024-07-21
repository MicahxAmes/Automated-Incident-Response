variable "aws_region" {
  description = "AWS region"
  default     = "us-east-2"
}

variable "lambda_s3_bucket" {
  description = "lambda-airp"
  type        = string
}

variable "lambda_s3_key" {
  description = "function.zip"
  type        = string
}