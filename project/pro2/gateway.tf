# create IGW
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.custom_VPC.id

  tags = {
    Name = "IGW"
  }
}

#---------------------------------------------------------#

# assign Elastic EIP1
resource "aws_eip" "EIP1" {
  depends_on = [aws_internet_gateway.IGW]

}

#------------------------------------------------#

# assign Elastic EIP2
resource "aws_eip" "EIP2" {
  depends_on = [aws_internet_gateway.IGW]

}

#---------------------------------------------------------#


# Create NAT gateway 1
resource "aws_nat_gateway" "NATGW1" {
  allocation_id = aws_eip.EIP1.id
  subnet_id     = aws_subnet.Public_Subnet1.id

  tags = {
    Name = "NATGW1"
  }
}

#------------------------------------------------#

# Create NAT gateway 2
resource "aws_nat_gateway" "NATGW2" {
  allocation_id = aws_eip.lb2.id
  subnet_id     = aws_subnet.Public_Subnet2.id

  tags = {
    Name = "NATGW2"
  }
}

#------------------------------------------------#