# Generate a random ID for unique bucket name
resource "random_id" "bucket_id" {
  byte_length = 4
}

# S3 Bucket for Lambda Code
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "my-lambda-bucket-${random_id.bucket_id.hex}"

  tags = {
    Name        = "LambdaCodeBucket"
    Environment = "Production"
    Owner       = "DevOpsTeam"
  }
}

# Upload Lambda Code to S3
resource "aws_s3_object" "lambda_code" {
  bucket = aws_s3_bucket.lambda_bucket.bucket
  key    = "spring-boot-lambda-test-0.0.1-SNAPSHOT.jar" # Path of Lambda code (can be uploaded manually)
  source = "/Users/nandandubey/eclipse-workspace/spring-boot-lambda-test/target/spring-boot-lambda-test-0.0.1-SNAPSHOT.jar"
}

# IAM Policy to allow Lambda to access S3 bucket
resource "aws_iam_policy" "lambda_s3_access_policy" {
  name = "LambdaS3AccessPolicy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Effect = "Allow",
        Resource = [
          aws_s3_bucket.lambda_bucket.arn,
          "${aws_s3_bucket.lambda_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Attach S3 Access Policy to Lambda Role
resource "aws_iam_role_policy_attachment" "lambda_s3_access_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_s3_access_policy.arn
}