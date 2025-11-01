resource "aws_instance" "ec2-pub-wattson" {
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.medium"
  tags = {
    Name = "ec2-wattson"
  }

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 15
    volume_type = "gp3"
  }

  key_name = var.public_key_wattson

  vpc_security_group_ids = [var.sgp_pub_id]

  subnet_id = var.sub_pub_id
}

# ebs.tf
resource "aws_ebs_volume" "example" {
  availability_zone = "us-east-1a"
  size = 15
  # Minimal configuration - will be filled after import
}