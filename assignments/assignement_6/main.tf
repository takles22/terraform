/*
1- Using Terraform, create three local workspaces named “dev”,”staging”, and ”prod”.
2- Create an EC2 instance configuration file which will change its instance type according to the chosen workspace as follows:
“dev” workspace will set the instance type to t2.micro.
“Staging” workspace will set the instance type to t2.medium.
“Prod” workspace will set the instance type to t2.large.
3- after finsihing , please remove all your created resources.
*/

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
  profile = "terraform_dev" # please provide your profile name
}

resource "aws_instance" "myec2" {
  ami           = "ami-06b09bfacae1453cb"
  instance_type = lookup(var.type, terraform.workspace)
  tags = {
    Name = lookup(var.tag_name, terraform.workspace)
  }
}
variable "type" {
  type = map(any)
  default = {
    default = "t2.micro"
    prod    = "t2.large"
    dev     = "t2.micro"
    staging = "t2.medium"
  }
}

variable "tag_name" {
  type = map(any)
  default = {
    default = "default_instance"
    prod    = "prod_instance"
    dev     = "dev_instance"
    staging = "staging_instance"
  }
}

######### Commands #######: 
# terraform init
# terraform workspace new prod
# terraform workspace new dev
# terraform workspace new staging
# terraform destroy -auto-destroy
