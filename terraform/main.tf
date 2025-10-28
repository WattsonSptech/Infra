module "vpc" {
  source = "./modules/vpc"
}
module "ec2" {
  source             = "./modules/ec2"
  sub_pub_id         = module.vpc.sub_pub_id
  public_key_wattson = module.keys.public_key_wattson
  sgp_pub_id         = module.security_group.sgp_pub_id
}
module "router_table" {
  source     = "./modules/router_table"
  vpc_id     = module.vpc.vpc_id
  igw_id     = module.vpc.igw_id
  sub_pub_id = module.vpc.sub_pub_id
}
module "keys" {
  source = "./modules/keys"
}
module "security_group" {
  source     = "./modules/security_groups"
  vpc_id     = module.vpc.vpc_id
  ec2_pub_ip = module.ec2.ec2_pub_ip
}

module "s3" {
  source = "./modules/s3"
}

module "iot_thing" {
  source = "./modules/iot_thing"
  lbd_data_dynamodb_arn = module.lambda.lbd_data_dynamodb_arn
  lbd_data_dynamodb_name = module.lambda.lbd_data_dynamodb_name
  lbd_data_s3_arn = module.lambda.lbd_data_s3_arn
  lbd_data_s3_name = module.lambda.lbd_data_s3_name
}

module "lambda" {
  source = "./modules/lambda"
  dynamodb_table_wattson_name = module.dynamodb.dynamodb_table_name
}

module "dynamodb" {
  source = "./modules/dynamodb"
}