output "bucket_name" {
  value = aws_s3_bucket.demo.bucket
}

output "lambda_name" {
  value = aws_lambda_function.read_s3_lambda.function_name
}
