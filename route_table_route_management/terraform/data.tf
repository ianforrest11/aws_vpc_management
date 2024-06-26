# data block to get private subnet id for use in creating other assets
data "aws_subnet" "default_vpc_private_subnet_1" {
  filter {
    name   = "tag:Name"
    values = ["default_vpc_private_subnet_1"]
  }
}

# data block to get public subnet id for use in creating other assets
data "aws_subnet" "default_vpc_public_subnet_1" {
  filter {
    name   = "tag:Name"
    values = ["default_vpc_public_subnet_1"]
  }
}

# data block to get private route table id for use in creating other assets
data "aws_route_table" "default_vpc_private_route_table_1" {
  filter {
    name   = "tag:Name"
    values = ["default_vpc_private_route_table_1"]
  }
}

# data block to get public route table id for use in creating other assets
data "aws_route_table" "default_vpc_public_route_table" {
  filter {
    name   = "tag:Name"
    values = ["default_vpc_public_route_table"]
  }
}

# data block to get internet gateway id for use in creating other assets
data "aws_internet_gateway" "default_vpc_igw" {
  filter {
    name   = "tag:Name"
    values = ["default_vpc_igw"]
  }
}

# data block to get nat gateway id for use in creating other assets
data "aws_nat_gateway" "default_vpc_nat_gateway" {
  filter {
    name   = "tag:Name"
    values = ["default_vpc_nat_gateway"]
  }
}
