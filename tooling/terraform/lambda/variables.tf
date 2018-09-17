variable "namespace" {
  description = "Namespace for the application"
}

variable "lambda_function_name" {
  description = "Name of the lambda function to create"
}

variable "s3_bucket_name" {
  description = "Name of the s3 bucket to dpeloy source to"
}

variable "aws_region" {
  description = "Region to deploy the function to"
}

variable "slack_api_key" {
  description = "API key for slack"
}
