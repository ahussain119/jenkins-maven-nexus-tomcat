# This file contains the Terraform configuration for the maven instance.
variable "ami" {}
variable "maven_sg_id" {}
variable "maven_subnet_id" {}
variable "maven_instance_type" {}
variable "key_name" {}

output "maven_ip_address" {
    value = aws_instance.maven.public_ip
}

# Creating an AWS EC2 instance resource for the maven instance
resource "aws_instance" "maven" {
    ami                          = var.ami
    instance_type                = var.maven_instance_type
    key_name                     = var.key_name
    security_groups              = [var.maven_sg_id]
    subnet_id                    = var.maven_subnet_id
    associate_public_ip_address  = true
    tags = {
        Name = "maven"
    }
}