resource "aws_spot_instance_request" "myresource" {
  count =  length(var.COMPONENTS)
  ami = "ami-074df373d6bafa625"
  instance_type = "t3.micro"
   vpc_security_group_ids = [aws_security_group.roboshop_sg.id] // ["sg-0980c269147cd7819"]
  wait_for_fulfillment = true
  tags = {
    Name = element(var.COMPONENTS, count.index)
  }
  }

resource "aws_security_group" "roboshop_sg" {
  name        = "roboshop_sg"
  description = "Allow  traffic"

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "roboshop-SG"
  }
}
output "security" {
  value = aws_security_group.roboshop_sg.id

}
resource "aws_ec2_tag" "my-tag" {
  count = length(var.COMPONENTS)
  key = "Name"
  resource_id = element(aws_spot_instance_request.myresource.*.spot_instance_id,count.index)
  value = element (var.COMPONENTS,count.index)
}

terraform {
  backend "s3" {
    bucket = "gomsy"
    key    = "gomsy/mykeytoroboshop"
    dynamodb_table = "gomsy2"
    region = "us-east-1"
  }
}
provider "aws" {
  region = "us-east-1"
}

output "PUBLIC_ID" {
  value = aws_spot_instance_request.myresource.*.public_ip
}


