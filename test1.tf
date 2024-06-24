# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
}

# 1- Define the VPC 
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

#2- Deploy the public subnet
resource "aws_subnet" "public_subnet1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
}

# Create the EC2 Instance
resource "aws_instance" "web" {
  ami           = "ami-0dfcb1ef8550277af"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet1.id
  tags = {
    Name = "dolfined_instance"
  }
}
