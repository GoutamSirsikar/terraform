resource "aws_spot_instance_request" "myresource" {
  count =  length(var.COMPONENTS)
  ami = "ami-074df373d6bafa625"
  instance_type = "t3.micro"
  vpc_security_group_ids = ["sg-0980c269147cd7819"]
  wait_for_fulfillment = true
  tags = {
    Name = element(var.COMPONENTS,count.index)
  }
  }


provider "aws" {
  region = "us-east-1"
}
