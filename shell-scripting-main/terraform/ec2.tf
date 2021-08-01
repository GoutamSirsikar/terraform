resource "aws_spot_instance_request" "myresource" {
  count =  length(var.COMPONENTS)
  ami = "ami-074df373d6bafa625"
  instance_type = "t3.micro"
  vpc_security_group_ids = ["sg-0980c269147cd7819"]
  wait_for_fulfillment = true
  tags = {
    Name = element(var.COMPONENTS, count.index)
  }
  }
resource "aws_ec2_tag" "my-tag" {
  count = length(var.COMPONENTS)
  key = "Name"
  resource_id = element(aws_spot_instance_request.myresource.*.spot_instance_id,count.index)
  value = element (var.COMPONENTS,count.index)
}

provider "aws" {
  region = "us-east-1"
}

output "PUBLIC_ID" {
  value = aws_spot_instance_request.myresource.*.public_ip
}


