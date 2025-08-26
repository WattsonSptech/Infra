variable "s3_buckets" {
    type = list(string)
    default = [ "bkt-wattson-raw", "bkt-wattson-trusted", "bkt-wattson-client" ]
}
