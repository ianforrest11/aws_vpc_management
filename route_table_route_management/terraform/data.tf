# data block to get vpc id for use in creating other assets
data "aws_vpc" "default_vpc" {
  filter {
    name   = "tag:Name"
    values = ["default_vpc"]
  }
}