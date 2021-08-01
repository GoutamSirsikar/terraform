resource "aws_spot_instance_request" "myresource" {
  count =  3
  ami = "ami-074df373d6bafa625"
  instance_type = "t3.micro"
  vpc_security_group_id = [sg-0980c269147cd7819]
  tags = {
    Name = "myinistance"
  }
  }


provider "aws" {
  region = "us-east-1"
}
