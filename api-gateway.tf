# Define API Gateway
resource "aws_api_gateway_rest_api" "lambda_api" {
  name        = "SpringBootLambdaAPI"
  description = "API Gateway to invoke Spring Boot Lambda"
}

# Define Resource under API Gateway (For example, "/lambda")
resource "aws_api_gateway_resource" "lambda_resource" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  parent_id   = aws_api_gateway_rest_api.lambda_api.root_resource_id
  path_part   = "{resource-id+}"
}

# Define GET Method for the Resource
resource "aws_api_gateway_method" "get_lambda_method" {
  rest_api_id   = aws_api_gateway_rest_api.lambda_api.id
  resource_id   = aws_api_gateway_resource.lambda_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# Integrate API Gateway with Lambda using AWS_PROXY
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.lambda_api.id
  resource_id             = aws_api_gateway_resource.lambda_resource.id
  http_method             = aws_api_gateway_method.get_lambda_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.spring_boot_lambda.invoke_arn
}

# Create a Lambda Permission to allow API Gateway to invoke the Lambda function
resource "aws_lambda_permission" "api_gateway_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.spring_boot_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.lambda_api.execution_arn}/*/*"
}

# Deploy API Gateway to a specific stage (e.g., "prod")
resource "aws_api_gateway_deployment" "lambda_deployment" {
  depends_on  = [aws_api_gateway_integration.lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  stage_name  = "prod"
}