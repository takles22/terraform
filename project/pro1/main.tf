# Create VPC  
  resource "aws_vpc" "dol_vpc" {
  cidr_block       = "10.30.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "dolfined_VPC"
  }
}

# create public subnet
resource "aws_subnet" "dol_Public" {
  vpc_id     = aws_vpc.dol_vpc.id
  cidr_block = "10.30.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "dolfined_Public"
  }
}

# create IGW
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.dol_vpc.id

  tags = {
    Name = "dolfined_igw"
  }
}
# attachec IGW to VPC
resource "aws_internet_gateway_attachment" "dol_igw" {
  internet_gateway_id = aws_internet_gateway.gw.id
  vpc_id              = aws_vpc.dol_vpc.id
}


# assign Elastic IP
resource "aws_eip" "lb" {
  depends_on = [aws_internet_gateway.gw]

}

# Create NAT gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.dol_Public.id

  tags = {
    Name = "dolfined_nat"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
 
}

# Display EIP and NAT gateway ID
output "display_EIP" {
    value = aws_eip.lb.public_ip
 
}
output "display_NAT" {
    value = aws_nat_gateway.nat_gw.id
 
}


# Create Rout Table

resource "aws_route_table" "dol_RT" {
  vpc_id = aws_vpc.dol_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "dolfined_Public_RT"
  }
}

# Assoisate Public table to public subnet
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.dol_Public.id
  route_table_id = aws_route_table.dol_RT.id
}

# Create Security group
resource "aws_security_group" "allow_HTTP" {
  name        = "dolfined_SG"
  description = "Allow HTTP inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.dol_vpc.id

  tags = {
    Name = "dolfined_SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_HTTP_ipv4" {
  security_group_id = aws_security_group.allow_HTTP.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_SSH_ipv4" {
  security_group_id = aws_security_group.allow_HTTP.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_HTTP_traffic_ipv4" {
  security_group_id = aws_security_group.allow_HTTP.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


# create instance
data "aws_ami" "amaz23" {
  most_recent = true
 

  filter {
    name   = "name"
    values = ["al2023-ami-2023.4.20240513.0-kernel-6.1-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}


# key_pair
resource "aws_key_pair" "dopper" {
  key_name   = "memo"
  public_key = file("~/.ssh/memo.pub")
}


#Create Instance named "web"
resource "aws_instance" "web" {
  ami           = data.aws_ami.amaz23.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = aws_subnet.dol_Public.id
  vpc_security_group_ids =[
    aws_security_group.allow_HTTP.id
  ]
  key_name      = "memo"
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("~/.ssh/memo")
    host     = self.public_ip
  }

  provisioner "remote-exec" {
      inline = [
        "sudo yum -y install nginx",
        "sudo systemctl start nginx"
    ]
  }

  tags = {
    Name = "dolfined_instance"
  }
}

#attache Security group to instance
# resource "aws_network_interface_sg_attachment" "sg_attachment" {
#   security_group_id    = aws_security_group.allow_HTTP.id
#   network_interface_id = data.aws_instance.web.network_interface_id
# }




