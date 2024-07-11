# This file contains the Terraform configuration for the tomcat instance.
variable "ami" {}
variable "tomcat_sg_id" {}
variable "tomcat_subnet_id" {}
variable "tomcat_instance_type" {}
variable "key_name" {}

output "tomcat_ip_address" {
  value = aws_instance.tomcat.public_ip
}


# Creating an AWS EC2 instance resource for the tomcat instance
resource "aws_instance" "tomcat" {
    ami                          = var.ami
    instance_type                = var.tomcat_instance_type
    key_name                     = var.key_name
    security_groups              = [var.tomcat_sg_id]
    subnet_id                    = var.tomcat_subnet_id
    associate_public_ip_address  = true
    tags = {
      Name = "tomcat"
    }
}