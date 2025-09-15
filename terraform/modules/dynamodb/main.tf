resource "aws_dynamodb_table" "dynamodb_table_wattson" {
  name           = "storage_iot_wattson"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  range_key      = "instant"
  attribute {
    name = "id"
    type = "S"
  }
  attribute {
    name = "instant"
    type = "S"
  }
}