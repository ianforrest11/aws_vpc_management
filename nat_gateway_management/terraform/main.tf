module "default_vpc_nat_gateway_public_subnet_1" {
  source                    = "git@github.com:ianforrest11/terraform_templates.git//aws/vpc_nat_gateway?ref=main"
  allocation_id             = data.aws_eip.default_vpc_nat_gateway_public_subnet_1_eip.id
  name                      = var.default_vpc_nat_gateway_public_subnet_1_name
  subnet_id                 = data.aws_subnet.default_vpc_public_subnet_1.id
}

module "default_vpc_nat_gateway_public_subnet_2" {
  source                    = "git@github.com:ianforrest11/terraform_templates.git//aws/vpc_nat_gateway?ref=main"
  allocation_id             = data.aws_eip.default_vpc_nat_gateway_public_subnet_2_eip.id
  name                      = var.default_vpc_nat_gateway_public_subnet_2_name
  subnet_id                 = data.aws_subnet.default_vpc_public_subnet_2.id
}