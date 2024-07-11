# Purpose: Define the variables that will be used in the Terraform configuration
variable "instance_type" {
    type = string
    description = "the type of EC2 instance"
}

variable "jenkins_instance_type" {
    type = string
    description = "the type of jenkins instance"
  
}

variable "vpc_cidr_block" {
    type = string
    description = "the CIDR block for the VPC"
}

variable "vpc_name" {
    type = string
    description = "the name of the VPC" 
}

variable "pub_subnet_cidr_blocks" {
    type = string
    description = "the CIDR blocks for the public subnets" 
}

variable "availability_zones" {
    type = string
    description = "the availability zones for the subnets"  
}

variable "domain_name" {
    type = string
    description = "the domain name for the route53 zone"
}

variable "ami_id" {
    type = string
    description = "jenkins ami"  
}

variable "nexus_instance_type" {
    type = string
    description = "the type of nexus instance"  
}

variable "sshkey" {
    type = string
    description = "the name of the ssh key"
}