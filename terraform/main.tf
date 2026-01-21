provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    s3     = "http://localhost:4566"
    lambda = "http://localhost:4566"
    iam    = "http://localhost:4566"
    logs   = "http://localhost:4566"
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../lambda/lambda_function.py"
  output_path = "${path.module}/lambda.zip"
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "demo" {
  bucket = "lambda-s3-demo-${random_id.suffix.hex}"
}

resource "aws_s3_object" "demo_file" {
  bucket  = aws_s3_bucket.demo.bucket
  key     = "example.txt"
  content = "Hello from S3 👋\nThis file was created locally via LocalStack."
}

resource "aws_lambda_function" "read_s3_lambda" {
  function_name = "read-s3-file-lambda"
  runtime       = "python3.12"
  handler       = "lambda_function.lambda_handler"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  role        = aws_iam_role.lambda_role.arn
  memory_size = 128
  timeout     = 10
}
