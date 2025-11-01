data "aws_caller_identity" "current" {}

locals {
  id_conta = data.aws_caller_identity.current.account_id

  s3_buckets = [
    "bkt-wattson-raw-${local.id_conta}",
    "bkt-wattson-trusted-${local.id_conta}",
    "bkt-wattson-client-${local.id_conta}",
    "athena-results-wattson-${local.id_conta}"
  ]

  folders = [
    "reclamacao_cliente/",
    "consumo/",
    "tensao_clima/"
  ]
}
# variable "s3_buckets" {
#     type = list(string)
#     default = [ "bkt-wattson-raw", "bkt-wattson-trusted", "bkt-wattson-client" ]
# }
