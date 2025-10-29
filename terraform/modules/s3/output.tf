output "bkt_athena_results_wattson" {
  value = aws_s3_bucket.bkt-wattson["athena-results-wattson-${local.id_conta}"].bucket
}
