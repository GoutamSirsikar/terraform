resource "aws_spot_instance_request" "mytest" {
  count =  length(var.COMPO)
  ami = "ami-074df373d6bafa625"
  instance_type = "t3.micro"
  vpc_security_group_ids = ["sg-0980c269147cd7819"]
  wait_for_fulfillment = true
  tags = {
    Name = element(var.COMPO, count.index)
  }
}
provider "aws" {
  region = "us-east-1"
}
output "PUBLIC_IP" {
  value = aws_spot_instance_request.mytest[0].public_ip
}

variable "COMPO" {}

