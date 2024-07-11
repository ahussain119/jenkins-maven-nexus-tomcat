# This file contains the Terraform configuration for the nexus instance.
variable "ami" {}
variable "nexus_sg_id" {}
variable "nexus_subnet_id" {}
variable "nexus_instance_type" {}
variable "key_name" {}

output "nexus_ip_address" {
    value = aws_instance.nexus.public_ip
}


# Creating an AWS EC2 instance resource for the nexus instance
resource "aws_instance" "nexus" {
    ami                          = var.ami
    instance_type                = var.nexus_instance_type
    key_name                     = var.key_name
    security_groups              = [var.nexus_sg_id]
    subnet_id                    = var.nexus_subnet_id
    associate_public_ip_address  = true
    tags = {
        Name = "nexus"
    }
    root_block_device {
        volume_size = 20
    }
}