module "default_vpc_private_route_table_1_route_1" {
  source                    = "git@github.com:ianforrest11/terraform_templates.git//aws/vpc_route_table_route?ref=main"
  destination_cidr_block    = var.default_route_table_route_destination_cidr_block
  nat_gateway_id            = data.aws_nat_gateway.default_vpc_nat_gateway_public_subnet_1.id
  route_table_id            = data.aws_route_table.default_vpc_private_route_table_1.id
  subnet_id                 = data.aws_subnet.default_vpc_private_subnet_1.id
}

module "default_vpc_private_route_table_2_route_1" {
  source                    = "git@github.com:ianforrest11/terraform_templates.git//aws/vpc_route_table_route?ref=main"
  destination_cidr_block    = var.default_route_table_route_destination_cidr_block
  nat_gateway_id            = data.aws_nat_gateway.default_vpc_nat_gateway_public_subnet_2.id
  route_table_id            = data.aws_route_table.default_vpc_private_route_table_2.id
  subnet_id                 = data.aws_subnet.default_vpc_private_subnet_2.id
}

module "default_vpc_public_route_table_1_route_1" {
  source                    = "git@github.com:ianforrest11/terraform_templates.git//aws/vpc_route_table_route?ref=main"
  destination_cidr_block    = var.default_route_table_route_destination_cidr_block
  gateway_id                = data.aws_internet_gateway.default_vpc_igw.id
  route_table_id            = data.aws_route_table.default_vpc_public_route_table_1.id
  subnet_id                 = data.aws_subnet.default_vpc_public_subnet_1.id # NEED TO CHECK
}

module "default_vpc_public_route_table_1_route_2" {
  source                    = "git@github.com:ianforrest11/terraform_templates.git//aws/vpc_route_table_route?ref=main"
  destination_cidr_block    = var.default_route_table_route_destination_cidr_block
  gateway_id                = data.aws_internet_gateway.default_vpc_igw.id
  route_table_id            = data.aws_route_table.default_vpc_public_route_table_1.id
  subnet_id                 = data.aws_subnet.default_vpc_public_subnet_2.id # NEED TO CHECK
}

