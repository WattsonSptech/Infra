variable "bkt_athena_results_wattson" {
    type = string
}

data "aws_caller_identity" "current" {}

locals {
  id_conta = data.aws_caller_identity.current.account_id
}