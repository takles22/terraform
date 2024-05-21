/*
1- Create an IAM user that has programmatic access with the appropertiate permissions to create EC2 instances, VPCs, and subnets. Use this user to do the below tasks.
2- Create a new VPC and a new public subnet, use any supported CIDR blocks. 
3- Create an EC2 instance of t2.micro type and assign a tag to it as follows name= “dolfined_instance”, ensue the instance will be assigned a public IP.
4- Ensure the EC2 instance is created inside the newly created VPC public subnet above.
5- Finally destroy the terraform deployed infrastructure.

*/
# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
  profile = "terraform_dev" # please provide your profile name
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

######### Commands #######: 
# terraform init
# terraform apply -auto-approve
# terraform destroy -auto-approve
