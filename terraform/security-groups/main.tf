# This Terraform configuration file creates three security groups in the VPC:
variable "vpc_id" {}

output "jenkins_ec2_sg" {
  value = aws_security_group.jenkins_ec2_sg.id
}

output "nexus_sg_id" {
  value = aws_security_group.nexus-sg.id
}

output "maven_sg_id" {
  value = aws_security_group.maven-sg.id
}

output "tomcat_sg_id" {
  value = aws_security_group.tomcat-sg.id
}

# Creating an EC2 security group and allowing SSH and HTTP traffic from the jumper and route53 security groups
resource "aws_security_group" "jenkins_ec2_sg" {
  vpc_id = var.vpc_id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg-22-80"
  }
}

# Creating a nexus security group and allowing on all ports traffic
resource "aws_security_group" "nexus-sg" {
  vpc_id = var.vpc_id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8081
    to_port = 8081
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Nexus-sg-22"
  }
}

# Creating a maven security group and allowing on all ports traffic
resource "aws_security_group" "maven-sg" {
  vpc_id = var.vpc_id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8082
    to_port = 8082
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Maven-sg-22"
  }
}

# Creating a tomcat security group and allowing on all ports traffic
resource "aws_security_group" "tomcat-sg" {
  vpc_id = var.vpc_id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Tomcat-sg-22"
  }
}


