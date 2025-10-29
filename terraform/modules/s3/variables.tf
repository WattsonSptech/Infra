data "aws_caller_identity" "current" {}

locals {
  id_conta = data.aws_caller_identity.current.account_id

  s3_buckets = [
    "bkt-wattson-raw-${local.id_conta}",
    "bkt-wattson-trusted-${local.id_conta}",
    "bkt-wattson-client-${local.id_conta}"
  ]
}

# variable "s3_buckets" {
#     type = list(string)
#     default = [ "bkt-wattson-raw", "bkt-wattson-trusted", "bkt-wattson-client" ]
# }
