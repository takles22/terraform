# Create VPC  
resource "aws_vpc" "custom_VPC" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "custom_VPC"
  }
}
#------------------------------------------------#