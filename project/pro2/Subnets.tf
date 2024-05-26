# create public Subnet 1
resource "aws_subnet" "Public_Subnet1" {
  vpc_id                  = aws_vpc.custom_VPC.id
  cidr_block              = "10.0.10.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public_Subnet1"
  }
}

#------------------------------------------------#

# create public Subnet 2
resource "aws_subnet" "Public_Subnet2" {
  vpc_id                  = aws_vpc.custom_VPC.id
  cidr_block              = "10.0.20.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public_Subnet2"
  }
}

#------------------------------------------------#

# create private Subnet 1
resource "aws_subnet" "Private_Subnet1" {
  vpc_id            = aws_vpc.custom_VPC.id
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.100.0/24"
  tags = {
    Name = "Private_Subnet1"
  }
}

#------------------------------------------------#

# create private Subnet 2
resource "aws_subnet" "Private_Subnet2" {
  vpc_id            = aws_vpc.custom_VPC.id
  availability_zone = "us-east-1b"
  cidr_block        = "10.0.200.0/24"
  tags = {
    Name = "Private_Subnet2"
  }
}

#------------------------------------------------#