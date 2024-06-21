module "default_vpc_igw" {
  source                    = "git@github.com:ianforrest11/terraform_templates.git//aws/vpc_internet_gateway?ref=main"
  name                      = var.default_vpc_igw_name
  vpc_id                    = data.aws_vpc.default_vpc.id
}