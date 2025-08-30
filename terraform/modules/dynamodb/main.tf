resource "aws_dynamodb_table" "dynamodb_table_wattson" {
  name           = "storage_iot_wattson"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "deviceId"
  range_key      = "ts"

  attribute {
    name = "deviceId"
    type = "S"
  }

  attribute {
    name = "ts"
    type = "N"
  }
}