resource "aws_spot_instance_request" "myresource" {
  count =  length(var.COMPONENTS)
  ami = "ami-074df373d6bafa625"
  instance_type = "t3.micro"
   vpc_security_group_ids = [aws_security_group.roboshop_sg.id]
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
    protocol         = "-1"
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
resource "aws_route53_record" "www" {
  count = length(var.COMPONENTS)
  zone_id = "Z08673361NPDJ3PFPH9S6"
  name    = element(var.COMPONENTS,count.index )
  type    = "A"
  ttl     = "300"
  records = element(aws_spot_instance_request.myresource.*.private_ip,count.index )
}
resource "null_resource" "run-shell-scripting" {
  depends_on = [aws_route53_record.www]
  count                     = length(var.COMPONENTS)
  provisioner "remote-exec" {
    connection {
      host                  = element(aws_spot_instance_request.myresource.*.public_ip, count.index)
      user                  = "centos"
      password              = "DevOps321"
    }

    inline = [
//      "cd /home/centos",
//      "git clone https://DevOps-Batches@dev.azure.com/DevOps-Batches/DevOps57/_git/shell-scripting",
//      "cd shell-scripting/roboshop",
//      "git pull",
//      "sudo make ${element(var.COMPONENTS, count.index)}"


      "git clone https://github.com/GoutamSirsikar/Devops.git",
      "cd /home/centos/Devops/shell-scripting-main/roboshop",
      "git pull",
     "sudo make ${element(var.COMPONENTS, count.index)}"
    ]
  }
}

//resource "null_resource" "run_shell_script" {
//  count             = length(var.COMPONENTS)
//  provisioner remote-exec {
//    connection {
//      host          = element(aws_spot_instance_request.myresource.*.public_ip,count.index )
//      user          = "centos"
//      password      = "DevOps321"
//    }
//  inline = [
//   "cd /home/centos",
//    "git clone https://github.com/GoutamSirsikar/Devops.git",
//    "cd shell-scripting-main/roboshop",
//    "sudo make ${element(var.COMPONENTS,count.index)}"
//  ]
//
//  }
//
//}





