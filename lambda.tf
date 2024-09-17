provider "aws" {
  region = var.aws_region
}

# IAM Role for Lambda Function
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach Lambda Execution Policy to Role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda Function Definition
resource "aws_lambda_function" "spring_boot_lambda" {
  function_name = "spring-boot-lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "com.geeks.terminal.handler.StreamLambdaHandler::handleRequest"
  runtime       = "java11"

  filename = "/Users/nandandubey/eclipse-workspace/spring-boot-lambda-test/target/spring-boot-lambda-test-0.0.1-SNAPSHOT.jar"

  memory_size   = 1024
  timeout       = 900

  environment {
    variables = {
      SPRING_PROFILES_ACTIVE = "prod"
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_policy_attachment
  ]
}

# Allow Lambda to be invoked by S3 (optional)
resource "aws_lambda_permission" "allow_s3_to_invoke" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.spring_boot_lambda.function_name
  principal     = "s3.amazonaws.com"

  source_arn = aws_s3_bucket.lambda_bucket.arn
}