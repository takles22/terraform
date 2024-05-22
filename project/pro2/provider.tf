terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  profile = "terraform-dev"
  region = "us-east-1"
}

# provider "aws" {
#   profile = "terraform-dev2"
#   alias = "west"
#   region  = "us-west-1"
# }
