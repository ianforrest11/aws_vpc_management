module "default_vpc_public_subnet_1_eip" {
  source                    = "git@github.com:ianforrest11/terraform_templates.git//aws/vpc_eip?ref=main"
  vpc                       = var.default_vpc_vpc_boolean
  name                      = var.default_vpc_public_subnet_1_eip_name
}

module "default_vpc_public_subnet_2_eip" {
  source                    = "git@github.com:ianforrest11/terraform_templates.git//aws/vpc_eip?ref=main"
  vpc                       = var.default_vpc_vpc_boolean
  name                      = var.default_vpc_public_subnet_2_eip_name
}