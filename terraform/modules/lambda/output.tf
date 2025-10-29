output "lmb_data_dynamodb_arn" {
  value = aws_lambda_function.lmb_data_dynamodb.arn
}

output "lmb_data_dynamodb_name" {
  value = aws_lambda_function.lmb_data_dynamodb.function_name
}

output "lbd_data_s3_arn" {
  value = aws_lambda_function.lbd_data_s3.arn
}

output "lbd_data_s3_name" {
  value = aws_lambda_function.lbd_data_s3.function_name
}

# output "lbd-files-s3-arn" {
#   value = aws_lambda_function.lbd-files-s3.arn
# }