module "default_vpc_eip" {
  source                    = "git@github.com:ianforrest11/terraform_templates.git//aws/vpc_eip?ref=main"
  vpc                       = var.default_vpc_vpc_boolean
  name                      = var.default_vpc_eip_name
}