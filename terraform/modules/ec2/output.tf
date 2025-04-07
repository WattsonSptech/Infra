output "ec2_pub_ip" {
  value = "${aws_instance.ec2-pub-wattson.private_ip}/32"
}
output "ec2_pub_ip_publico" {
  value = "${aws_instance.ec2-pub-wattson.public_ip}/32"
}
output "ec2_pub_id" {
  value = aws_instance.ec2-pub-wattson.id
}
