output "lbd_data_s3_arn" {
  value = aws_lambda_function.lbd_data_s3.arn
}

output "lbd_data_s3_name" {
  value = aws_lambda_function.lbd_data_s3.function_name
}