data "archive_file" "name" {
  output_path = "../script_lambda/lmb_data_dynamodb.zip"
  source_file = "../script_lambda/lmb_data_dynamodb.py"
  type = "zip"
}
resource "aws_lambda_function" "lbd_data_dynamodb" {
  function_name = "lmb_data_dynamodb"
  role          = "arn:aws:iam::${local.id_account}:role/LabRole"
  handler       = "lmb_data_dynamodb.lambda_handler"
  runtime       = "python3.10"
  filename      = "../script_lambda/lmb_data_dynamodb.zip"
  timeout       = 30

  environment {
    variables = {
      TABLE_NAME = var.dynamodb_table_wattson_name
    }
  }
}

# resource "aws_lambda_function" "lbd-files-s3" {
#   function_name = "lbd-files-s3"
#   role          = "arn:aws:iam::131640542086:role/LabRole"
#   handler       = "lambda_function.lambda_handler"
#   runtime       = "python3.10"
#   filename      = "script_lambda/lambda_function.zip"
#   timeout       = 30

#   layers = [
#     "arn:aws:lambda:us-east-1:336392948345:layer:AWSSDKPandas-Python310:1"
#   ]
# }
