resource "aws_route_table" "rtb-ichiban" {
  vpc_id = var.vpc_id

  tags = {
    Name = "rtb-ichiban"
  }
}

resource "aws_route" "internet-acess" {
  route_table_id         = aws_route_table.rtb-ichiban.id
  gateway_id             = var.igw_id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "rt_subnet_pub" {
  subnet_id      = var.sub_pub_id
  route_table_id = aws_route_table.rtb-ichiban.id
}
