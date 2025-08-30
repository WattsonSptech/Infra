output "lbd_data_dynamodb_arn" {
  value = aws_lambda_function.lbd_data_dynamodb.arn
}

output "lbd_data_dynamodb_name" {
  value = aws_lambda_function.lbd_data_dynamodb.function_name
}

# output "lbd-files-s3-arn" {
#   value = aws_lambda_function.lbd-files-s3.arn
# }