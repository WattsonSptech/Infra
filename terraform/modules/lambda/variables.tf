data "aws_caller_identity" "current" {}

variable "dynamodb_table_wattson_name" {
  type = string
}  

locals {
  id_account = data.aws_caller_identity.current.account_id
}