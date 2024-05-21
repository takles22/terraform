/*
1- Create a user with admin access privilages and use this user account to create resources.
2- Using terraform, create two EC2 instances, one in us-east-1 and the other in us-west-1 regions, respectively.
3- Using the AWS Console, create a new EC2 instance in us-east-1 region , tag it with “manually_created”.
4- You are required to control all your resources from terraform on your local machine, Please do the needeful configuration actions to achieve this.
5- At end, your state file should include all the created EC2 instances, please use your terminal to list all your resources without accessing your state file.
6- Your colleague installed unwanted applications on one of your EC2 instances manually using the AWS Console and you want to revert its earlier state, what could you do to maintain the desired state of that instance? Please do the needful action.
Finally, destroy your deployed infrastructure.

*/

# Configure the AWS Providers
provider "aws" {
  region  = "us-east-1"
  profile = "terraform_dev" # please provide your profile name
}

provider "aws" {
  alias   = "west"
  region  = "us-west-1"
  profile = "terraform_dev" # please provide your profile name
}
# Create the EC2 Instances
resource "aws_instance" "first_instance" {
  ami           = "ami-01c647eace872fc02"
  instance_type = "t2.micro"
}

resource "aws_instance" "second_instance" {
  provider      = aws.west
  ami           = "ami-0f1ee917b10382dea"
  instance_type = "t2.micro"
}

######### Commands #######: 
# terraform init
# terraform apply -auto-approve
# create the maunally EC2 instance and then use the other file configuration to import it under terraform control.
# terraform state list
# terraform apply -auto-approve >>>>> to maintain the desired state and ignore any manual changes.
# terraform destroy -auto-destroy
