module "main_vpc_creation" {
  source           = "git@github.com:ianforrest11/terraform_templates.git//aws/vpc_vpc?ref=main"
  cidr_block       = var.main_vpc_cidr_block
  instance_tenancy = var.main_vpc_instance_tenancy
  name             = var.main_vpc_name
}