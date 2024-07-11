# This Terraform configuration file creates a VPC with public and private subnets, internet gateway, route tables, and NAT gateway.
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
}

variable "vpc_name" {
  description = "Name of the VPC"
}

variable "pub_subnet_cidr_blocks" {
  description = "CIDR blocks for the public subnets"
}

variable "availability_zones" {
  description = "Availability zones for the subnets"
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.Pub_subnets.id
}

# Creating an AWS VPC resource
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

# Creating AWS public subnets
resource "aws_subnet" "Pub_subnets" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.pub_subnet_cidr_blocks
  availability_zone = var.availability_zones

  tags = {
    Name = "${var.vpc_name}-pub-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# Creating a public route table
resource "aws_route_table" "rt_pub" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.vpc_name}-rt-pub"
  }
}

# Creating a route table association for public subnets
resource "aws_route_table_association" "Pub2rt_association" {
  subnet_id      = aws_subnet.Pub_subnets.id
  route_table_id = aws_route_table.rt_pub.id
}

# Creating a route for the public route table
resource "aws_route" "rt_pub_default" {
  route_table_id         = aws_route_table.rt_pub.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}