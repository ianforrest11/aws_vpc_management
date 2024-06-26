# data block to get subnet id for use in creating other assets
data "aws_subnet" "default_vpc_public_subnet_1" {
  filter {
    name   = "tag:Name"
    values = ["default_vpc_public_subnet_1"]
  }
}

# data block to get eip id for use in creating other assets
data "aws_eip" "default_vpc_eip" {
  filter {
    name   = "tag:Name"
    values = ["default_vpc_eip"]
  }
}