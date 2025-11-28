data "aws_caller_identity" "current" {}

locals {
  id_account = data.aws_caller_identity.current.account_id
}