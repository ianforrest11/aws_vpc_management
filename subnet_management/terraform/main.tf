module "private_subnet_1_creation" {
  source                    = "git@github.com:ianforrest11/terraform_templates.git//aws/vpc_subnet?ref=main"
  cidr_block                = var.private_subnet_1_cidr_block
  map_public_ip_on_launch   = var.private_subnet_1_map_public_ip_on_launch
  name                      = var.private_subnet_1_name
  vpc_id                    = data.aws_vpc.default_vpc.id
}

module "public_subnet_1_creation" {
  source                    = "git@github.com:ianforrest11/terraform_templates.git//aws/vpc_subnet?ref=main"
  cidr_block                = var.public_subnet_1_cidr_block
  map_public_ip_on_launch   = var.public_subnet_1_map_public_ip_on_launch
  name                      = var.public_subnet_1_name
  vpc_id                    = data.aws_vpc.default_vpc.id
}

