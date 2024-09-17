# Output Lambda Function ARN
output "lambda_function_arn" {
  description = "The ARN of the deployed Lambda function"
  value       = aws_lambda_function.spring_boot_lambda.arn
}

# Output S3 Bucket Name
output "lambda_s3_bucket" {
  description = "The S3 bucket where Lambda code is stored"
  value       = aws_s3_bucket.lambda_bucket.bucket
}

# Output API Gateway URL (if you are using API Gateway integration)
output "api_gateway_url" {
  description = "The URL of the deployed API Gateway"
  value       = "${aws_api_gateway_deployment.lambda_deployment.invoke_url}/lambda"
}