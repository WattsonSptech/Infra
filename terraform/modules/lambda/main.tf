resource "aws_lambda_function" "lbd_data_s3" {
  function_name = "lmb_data_s3"
  role          = "arn:aws:iam::${local.id_account}:role/LabRole"
  handler       = "lmb_data_s3.lambda_handler"
  runtime       = "python3.10"
  filename      = "../script_lambda/lmb_data_s3.zip"
  timeout       = 306
}
