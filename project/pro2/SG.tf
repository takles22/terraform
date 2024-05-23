# Create Security group WebSG

resource "aws_security_group" "WebSG" {
  name        = "WebSG"
  description = "Allow HTTP inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.custom_VPC.id
  tags = {
    Name = "WebSG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_HTTP_ipv4" {
  security_group_id = aws_security_group.WebSG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_SSH_ipv4" {
  security_group_id = aws_security_group.WebSG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_HTTP2_traffic_ipv4" {
  security_group_id = aws_security_group.WebSG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

#------------------------------------------------#

# Create Security group ALBSG

resource "aws_security_group" "ALBSG" {
  name        = "ALBSG"
  description = "Allow HTTP inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.custom_VPC.id

  tags = {
    Name = "ALBSG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_HTTP1_ipv4" {
  security_group_id = aws_security_group.ALBSG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_HTTP1_traffic_ipv4" {
  security_group_id = aws_security_group.ALBSG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

#------------------------------------------------#
