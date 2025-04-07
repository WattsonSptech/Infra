output "vpc_id" {
  value = aws_vpc.vpc-wattson.id
}
output "sub_pub_id" {
  value = aws_subnet.sub-pub-wattson.id
}
output "igw_id" {
  value = aws_internet_gateway.igw-wattson.id
}
