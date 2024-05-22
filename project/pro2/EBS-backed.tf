# Data Resource instance
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

#------------------------------------------------#

# key_pair
resource "aws_key_pair" "dopper" {
  key_name   = "memo"
  public_key = file("~/.ssh/memo.pub")
}


#------------------------------------------------#

#Create EBS-Backed EC2 named "web_Server1"
resource "aws_instance" "Web_Server1" {
  ami           = data.aws_ami.amaz23.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.Private_Subnet1.id
  ephemeral_block_device {
    device_name = "/dev/sdb"
    virtual_name = "ephemeral0"
  }
  vpc_security_group_ids =[
  aws_security_group.WebSG.id
  ]
  key_name      = "memo"
  user_data = <<EOF
        #!bin/bash,
        sudo yum update -y
        yum install httpd -y # installs apache (httpd) service
        systemctl start httpd # starts httpd service
        systemctl enable httpd # enable httpd to auto-start at system boot
        echo " This is server *1* in AWS Region US-EAST-1 in AZ US-EAST-1A " > /var/www/html/index.html
        EOF
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("~/.ssh/memo")
    host     = self.public_ip 
  }

  provisioner "remote-exec" {
      inline = [
        "curl http://instancepublicip"
    ]
  }
  tags = {
    Name = "Web_Server1"
  }
}

#------------------------------------------------#

#Create EBS-Backed EC2 named "web_Server2"
resource "aws_instance" "Web_Server2" {
  ami           = data.aws_ami.amaz23.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.Private_Subnet2.id
  ephemeral_block_device {
    device_name = "/dev/sdb"
    virtual_name = "ephemeral0"
  }
  vpc_security_group_ids =[
  aws_security_group.WebSG.id
  ]
  key_name      = "memo"
  user_data = <<EOF
        #!bin/bash,
        sudo yum update -y
        yum install httpd -y # installs apache (httpd) service
        systemctl start httpd # starts httpd service
        systemctl enable httpd # enable httpd to auto-start at system boot
        echo " This is server *2* in AWS Region US-EAST-1 in AZ US-EAST-1B " > /var/www/html/index.html
        EOF
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("~/.ssh/memo")
    host     = self.public_ip 
  }
  provisioner "remote-exec" {
      inline = [
        "curl http://instancepublicip"
    ]
  }

  tags = {
    Name = "Web_Server1"
  }
}

#------------------------------------------------#

#shown Public IPS
output "pub1_ip" {
    value = aws_instance.web_Server1.public_ip
  
}

output "pub2_ip" {
    value = aws_instance.web_Server2.public_ip
  
}

#------------------------------------------------#