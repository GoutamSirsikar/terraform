resource "aws_spot_instance_request" "myresource" {
  ami = "ami-074df373d6bafa625"
  instance_type = "t3.micro"
  tags = {
    Name    = "MyInstance"
  }
}
provider "aws" {
  region = "us-east-1"
}
