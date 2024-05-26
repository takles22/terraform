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
  ami                    = data.aws_ami.amaz23.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.Public_Subnet1.id
  vpc_security_group_ids = [aws_security_group.WebSG.id]
  key_name               = aws_key_pair.dopper.key_name
  user_data              = data.cloudinit_config.cloudinit-example.rendered
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/memo")
    host        = self.public_ip
  }

  provisioner "local-exec" {
    command = "curl http://${self.public_ip} | bash"
  }
  tags = {
    Name = "Web_Server1"
  }
}

#------------------------------------------------#
# create ebs volume 

resource "aws_ebs_volume" "volume_1" {
  availability_zone = "us-east-1a"
  size              = 20
  type              = "gp2"

  tags = {
    Name = "vol-server1"
  }
}

#------------------------------------------------#
# attachement vol1

resource "aws_volume_attachment" "ebs_att1" {
  device_name  = "/dev/sdh"
  volume_id    = aws_ebs_volume.volume_1.id
  instance_id  = aws_instance.Web_Server1.id
  skip_destroy = true
}

#------------------------------------------------#

#Create EBS-Backed EC2 named "Web_Server2"
resource "aws_instance" "Web_Server2" {
  ami                    = data.aws_ami.amaz23.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.Public_Subnet2.id
  vpc_security_group_ids = [aws_security_group.WebSG.id]
  key_name               = aws_key_pair.dopper.key_name
  user_data              = data.cloudinit_config.cloudinit-example2.rendered
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/memo")
    host        = self.public_ip
  }

  provisioner "local-exec" {
    command = "curl http://${self.public_ip} | bash"
  }
  tags = {
    Name = "Web_Server2"
  }
}

# #------------------------------------------------#
# # create ebs volume 

resource "aws_ebs_volume" "volume_2" {
  availability_zone = "us-east-1b"
  size              = 20
  type              = "gp2"

  tags = {
    Name = "vol-server2"
  }
}

#------------------------------------------------#
# attachement vol2

resource "aws_volume_attachment" "ebs_att2" {
  device_name  = "/dev/sdh"
  volume_id    = aws_ebs_volume.volume_2.id
  instance_id  = aws_instance.Web_Server2.id
  skip_destroy = true
}

#------------------------------------------------#

#------------------------------------------------#

#shown Public IPS
output "pub1_ip" {
  value = aws_instance.Web_Server1.public_ip

}

output "pub2_ip" {
  value = aws_instance.Web_Server2.public_ip

}

#------------------------------------------------#