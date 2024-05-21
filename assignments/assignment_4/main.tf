/*
1- Use Terraform to create an EC2 instance and install on it an apache server using a terraform remote provisioner.
2- Use a terraform local provisioner to save the private ip address of the created instance on your local machine. 
3- After finsishing the above tasks, remove any deployed infrastructure without any interactive prompt.


*/

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
  profile = "terraform_dev" # please provide your profile name
}

# Create EC2 instance
# create ssh key pair on your local machine and use the below to upload that key on your aws account - start by issue that command on your terminal "ssh-keygen"
resource "aws_key_pair" "deployer" {
  key_name   = "ec2_key"
  public_key = file("~/.ssh/ec2_key.pub") # please point to your public key in your local path- it may be different according to your exact path.
}

resource "aws_instance" "nginx" {
  ami           = "ami-022e1a32d3f742bd8"
  instance_type = "t2.micro"
  key_name      = "ec2_key"
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/ec2_key") # please point to your private key in your local path- it may be different according to your exact path.
    host        = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install nginx",
      "sudo systemctl start nginx"
    ]
  }
}


######### Commands #######: 
# terraform init
# terraform apply -auto-approve
# terraform destroy -auto-destroy
