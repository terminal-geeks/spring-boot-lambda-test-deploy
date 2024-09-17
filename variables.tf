# AWS region variable
variable "aws_region" {
  description = "AWS region where the infrastructure is created"
  default     = "us-east-1"
}

# Optional: Define Lambda function name, memory size, etc.
variable "lambda_function_name" {
  description = "Lambda function name"
  default     = "spring-boot-lambda"
}