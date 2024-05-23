# Create Public Route Table

resource "aws_route_table" "Public_RT" {
  vpc_id = aws_vpc.custom_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "Public_RT"
  }
}

#------------------------------------------------#

# Assoisate Public table to public1 subnet
resource "aws_route_table_association" "Public1" {
  subnet_id      = aws_subnet.Public_Subnet1.id
  route_table_id = aws_route_table.Public_RT.id
}

#------------------------------------------------#

# Assoisate Public table to public2 subnet
resource "aws_route_table_association" "Public2" {
  subnet_id      = aws_subnet.Public_Subnet2.id
  route_table_id = aws_route_table.Public_RT.id
}



#------------------------------------------------#

# Create Private Route 1 Table

resource "aws_route_table" "Private_RT_1" {
  vpc_id = aws_vpc.custom_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NATGW1.id
  }

  tags = {
    Name = "Private_RT_1"
  }
}

#------------------------------------------------#

# Create Private Route 2 Table

resource "aws_route_table" "Private_RT_2" {
  vpc_id = aws_vpc.custom_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NATGW2.id
  }

  tags = {
    Name = "Private_RT_2"
  }
}

#------------------------------------------------#

# Assoisate Public table to private subnet 1
resource "aws_route_table_association" "private1_T" {
  subnet_id     = aws_subnet.Private_Subnet1.id
  route_table_id = aws_route_table.Public_RT.id
}

#------------------------------------------------#

# Assoisate Public table to private subnet 2
resource "aws_route_table_association" "private2_T" {
  subnet_id     = aws_subnet.Private_Subnet2.id
  route_table_id = aws_route_table.Public_RT.id
}

#------------------------------------------------#