module "default_vpc_nat_gateway" {
  source                    = "git@github.com:ianforrest11/terraform_templates.git//aws/vpc_nat_gateway?ref=main"
  allocation_id             = data.aws_eip.default_vpc_eip.id
  name                      = var.default_vpc_nat_gateway_name
  subnet_id                 = data.aws_subnet.default_vpc_public_subnet_1.id
}