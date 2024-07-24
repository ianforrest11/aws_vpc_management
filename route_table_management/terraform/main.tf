module "default_vpc_public_route_table_1" {
  source                    = "git@github.com:ianforrest11/terraform_templates.git//aws/vpc_route_table?ref=main"
  name                      = var.default_vpc_public_route_table_1_name
  vpc_id                    = data.aws_vpc.default_vpc.id
}

module "default_vpc_private_route_table_1" {
  source                    = "git@github.com:ianforrest11/terraform_templates.git//aws/vpc_route_table?ref=main"
  name                      = var.default_vpc_private_route_table_1_name
  vpc_id                    = data.aws_vpc.default_vpc.id
}

module "default_vpc_private_route_table_2" {
  source                    = "git@github.com:ianforrest11/terraform_templates.git//aws/vpc_route_table?ref=main"
  name                      = var.default_vpc_private_route_table_2_name
  vpc_id                    = data.aws_vpc.default_vpc.id
}