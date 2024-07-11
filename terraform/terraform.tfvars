# This file contains the variables that are used in the main.tf file
# define the variables
vpc_cidr_block = "10.0.0.0/16"
vpc_name = "project1"
pub_subnet_cidr_blocks = "10.0.1.0/24"
availability_zones = "ca-central-1a"

ami_id = "ami-0c9f6749650d5c0e3"
jenkins_instance_type = "t2.medium"
nexus_instance_type = "t3.xlarge"
instance_type = "t2.medium"

domain_name = "URL"
sshkey = "jenkins"