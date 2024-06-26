# aws_vpc_management
repository for managing AWS VPCs and related resources for portfolio AWS account

# modules included:
- eip management
- igw management
- nat gateway management
- route table management
- route table route management
- subnet management
- vpc management

# eip mangement
- This module handles the creation and management of Elastic IPs (EIPs) in AWS. An EIP is a static, public IP address designed for dynamic cloud computing, allowing you to mask the failure of an instance or software by rapidly remapping the address to another instance in your account.  This readme will walk through the creation of an EIP used by the default VPC and later associated with the default VPC's NAT Gateway
- First, navigate to `eip_management/terraform/main.tf` and add the following module definition
```
module "default_vpc_eip" {
  source = "git@github.com:ianforrest11/terraform_templates.git//aws/vpc_eip?ref=main"
  vpc    = var.default_vpc_vpc_boolean
  name   = var.default_vpc_eip_name
}
```
- Next, navigate to `eip_management/terraform/variables.tf` and add placeholder variables for the EIP name and VPC boolean:
```
variable "default_vpc_eip_name" {}
variable "default_vpc_vpc_boolean" {}
```
- Next, navigate to `eip_management/terraform/terraform.tfvars` and add the following variable assignments:
```
default_vpc_eip_name     = "default_vpc_eip"
default_vpc_vpc_boolean  = true
```
- Once the updated configuration is pushed to the main branch, the .github/workflows/terraform.yml workflow will pick it up and create the EIP `default_vpc_eip` in AWS


# igw management
- This module creates and internet gateway, which is a horizontally scaled, redundant, and highly available VPC component that facilitates communication between instances in your VPC and the internet. It allows instances in your VPC to initiate outbound connections to the internet and enables incoming traffic from the internet to reach instances with public IP addresses. The Internet Gateway ensures that instances in the VPC can interact with the internet while maintaining network isolation. It performs network address translation (NAT) for instances with public IP addresses, allowing them to communicate with the internet while preserving the private IP addresses within the VPC.
- For example, to create a `dev` internet gateway using the `default` VPC:
  - Navigate to `igw_management/terraform/main.tf` and add a module called `dev_vpc_igw`
  - Set the `source` variable to `git@github.com:ianforrest11/terraform_templates.git//aws/vpc_igw?ref=main`
  - Define required variable `name` as `var.dev_vpc_igw_name`
  - Use `data` Terraform resource to associate `vpc_id` to the dev VPC `data.aws_vpc.dev_vpc.id`, assuming it is created.  If you'd like to use a different vpc, please specify the variable like the others
- Second, navigate to `igw_management/variables/terraform.tfvars` and add a variable for `name` like so: `dev_vpc_igw_name = "dev_vpc_igw"`
- Third, navigate to the `igw_management/terraform/variables.tf` file and add placeholder variables to recognize the variables we added in the previous step.  They can be as simple as one line: `variable "dev_vpc_igw_name" {}`
- once this updated configuration is pushed to the `main` branch, the `.github/workflows/terraform.yml` workflow will pick it up and create igw `dev_vpc_igw` in AWS

# nat gateway management
- This module creates and manages NAT Gateways, enabling instances in a private subnet to connect to the internet or other AWS services while preventing the internet from initiating a connection with those instances.  This readme will walk through the process of creating the NAT Gateway attached to default_vpc's public subnet
- To use, first navigate to `nat_gateway_management/terraform/main.tf` and add the following module definition:
```
  module "default_vpc_nat_gateway" {
  source                    = "git@github.com:ianforrest11/terraform_templates.git//aws/vpc_nat_gateway?ref=main"
  allocation_id             = data.aws_eip.default_vpc_eip.id
  name                      = var.default_vpc_nat_gateway_name
  subnet_id                 = data.aws_subnet.default_vpc_public_subnet_1.id
  }
```
- Next, navigate to `nat_gateway_management/terraform/data.tf` and ensure the following data blocks are present to retrieve the necessary subnet and EIP information:
```
# Data block to get subnet ID for use in creating other assets
data "aws_subnet" "default_vpc_public_subnet_1" {
  filter {
    name   = "tag:Name"
    values = ["default_vpc_public_subnet_1"]
  }
}

# Data block to get EIP ID for use in creating other assets
data "aws_eip" "default_vpc_eip" {
  filter {
    name   = "tag:Name"
    values = ["default_vpc_eip"]
  }
}
```
- Next, navigate to `nat_gateway_management/terraform/variables.tf` and add a placeholder variable for the NAT Gateway name:
```
variable "default_vpc_nat_gateway_name" {}
```
- Next, navigate to `nat_gateway_management/terraform/terraform.tfvars` and add the following variable assignment:
```
default_vpc_nat_gateway_name = "default_vpc_nat_gateway"
```
- Once the updated configuration is pushed to the main branch, the `.github/workflows/terraform.yml` workflow will pick it up and create the NAT Gateway `default_vpc_nat_gateway` in AWS

# route table management
- This module handles the creation and management of route tables, which contain a set of rules (called routes) that are used to determine where network traffic from your subnet or gateway is directed. This readme will walk through the process of creating the existing public and private route tables associated wiht the default vpc's subnets
- First, navigate to `route_table_management/terraform/main.tf` and add the following module definitions:
```
module "default_vpc_public_route_table" {
  source = "git@github.com:ianforrest11/terraform_templates.git//aws/vpc_route_table?ref=main"
  name   = var.default_vpc_public_route_table_name
  vpc_id = data.aws_vpc.default_vpc.id
}

module "default_vpc_private_route_table_1" {
  source = "git@github.com:ianforrest11/terraform_templates.git//aws/vpc_route_table?ref=main"
  name   = var.default_vpc_private_route_table_1_name
  vpc_id = data.aws_vpc.default_vpc.id
}
```
- Next, navigate to `route_table_management/terraform/data.tf` and ensure the following data block is present to retrieve the necessary VPC information:
```
# Data block to get VPC ID for use in creating other assets
data "aws_vpc" "default_vpc" {
  filter {
    name   = "tag:Name"
    values = ["default_vpc"]
  }
}
```
- Next, navigate to `route_table_management/terraform/variables.tf` and add placeholder variables for the route table names:
```
variable "default_vpc_private_route_table_1_name" {}
variable "default_vpc_public_route_table_name" {}
```
- Next, navigate to `route_table_management/terraform/terraform.tfvars` and add the following variable assignments:
```
default_vpc_private_route_table_1_name = "default_vpc_private_route_table_1"
default_vpc_public_route_table_name    = "default_vpc_public_route_table"
```
- Once the updated configuration is pushed to the main branch, the `.github/workflows/terraform.yml` workflow will pick it up and create the route tables `default_vpc_public_route_table` and `default_vpc_private_route_table_1` in AWS

# route table route management
- This module manages routes within the route tables, specifying how to direct traffic destined for various IP address ranges.  This readme will walk through the creation of default routes for the public and private route tables
- First, navigate to `route_table_route_management/terraform/main.tf` and add the following module definitions:
```
module "default_vpc_private_route_table_1_route_1" {
  source                    = "git@github.com:ianforrest11/terraform_templates.git//aws/vpc_route_table_route?ref=main"
  destination_cidr_block    = var.default_vpc_private_route_table_1_route_1_destination_cidr_block
  nat_gateway_id            = data.aws_nat_gateway.default_vpc_nat_gateway.id
  route_table_id            = data.aws_route_table.default_vpc_private_route_table_1.id
  subnet_id                 = data.aws_subnet.default_vpc_private_subnet_1.id
}

module "default_vpc_public_route_table_route_1" {
  source                    = "git@github.com:ianforrest11/terraform_templates.git//aws/vpc_route_table_route?ref=main"
  destination_cidr_block    = var.default_vpc_public_route_table_route_1_destination_cidr_block
  gateway_id                = data.aws_internet_gateway.default_vpc_igw.id
  route_table_id            = data.aws_route_table.default_vpc_public_route_table.id
  subnet_id                 = data.aws_subnet.default_vpc_public_subnet_1.id
}
```
- Many of these data resources are configured in the `data.tf` file.  If different resources are needed, please add them in `data.tf`, e.g.:
```
# Data block to get private route table ID for use in creating other assets
data "aws_route_table" "default_vpc_private_route_table_1" {
  filter {
    name   = "tag:Name"
    values = ["default_vpc_private_route_table_1"]
  }
}
```
- Next, navigate to `route_table_route_management/terraform/variables.tf` and add placeholder variables for the route definitions:
```
variable "default_vpc_private_route_table_1_route_1_destination_cidr_block" {}
variable "default_vpc_public_route_table_route_1_destination_cidr_block" {}
```
- Navigate to route_table_route_management/terraform/terraform.tfvars and add the following variable assignments:
```
default_vpc_private_route_table_1_route_1_destination_cidr_block = "0.0.0.0/0"
default_vpc_public_route_table_route_1_destination_cidr_block    = "0.0.0.0/0"
```
- Once the updated configuration is pushed to the main branch, the `.github/workflows/terraform.yml` workflow will pick it up and create the routes in the `default_vpc_private_route_table_1` and `default_vpc_public_route_table` in AWS

# subnet management
- This module creates AWS subnets, which are segmented portions of an AWS VPC's IP address range where you can place groups of isolated resources. Subnets allow you to organize your AWS resources within a VPC and provide a layer of network security. Each subnet resides in one Availability Zone (AZ) and can have different configurations, such as public or private accessibility. Public subnets have routes to an Internet Gateway for internet access, while private subnets use NAT gateways or NAT instances for outbound internet access. Subnets play a crucial role in defining the network architecture of your AWS infrastructure, enabling you to deploy and manage applications securely and efficiently within the AWS cloud.
- The subnet naming convention is `SUBNETTYPE_subnet_SUBNETTYPENUMBER`
- For example, to create a second public subnet:
  - Navigate to `subnet_management/terraform/main.tf` and add a module called `public_subnet_2_creation`
  - Set the `source` variable to `git@github.com:ianforrest11/terraform_templates.git//aws/vpc_subnet?ref=main`
  - Define required variables `cidr_block`, `map_public_ip_on_launch`, & `name` like `var.VARIABLENAME`
  - Use `data` Terraform resource to associate `vpc_id` to the default VPC: `data.aws_vpc.default_vpc.id`.  If you'd like to use a different vpc, please specify the variable like the others 
  - Optionally set `availability_zone` like other variables if specifying a specific availability zone. 
  - See the example below:
```
module "public_subnet_2_creation" {
  source                    = "git@github.com:ianforrest11/terraform_templates.git//aws/vpc_subnet?ref=main"
  cidr_block                = var.public_subnet_2_cidr_block
  map_public_ip_on_launch   = var.public_subnet_2_map_public_ip_on_launch
  name                      = var.public_subnet_2_name
  vpc_id                    = data.aws_vpc.default_vpc.id
}
```
- Second, navigate to `subnet_management/variables/terraform.tfvars` and add variables for every `var.` parameter used above.  Determining `cidr_block` is outside the scope of this project. For example:
```
public_subnet_2_cidr_block               = "10.0.3.0/24"
public_subnet_2_map_public_ip_on_launch  = true
public_subnet_2_name                     = "public_subnet_2"
```
  - please note that if you are creating a `private` subnet, the value of `map_public_ip_on_launch` should be `false`
- Third, navigate to the `subnet_management/terraform/variables.tf` file and add placeholder variables to recognize the variables we added in the previous step.  They can be as simple as one line: 
```
variable "public_subnet_2_cidr_block" {}
variable "public_subnet_2_map_public_ip_on_launch" {}
variable "public_subnet_2_name" {}
```
- once this updated configuration is pushed to the `main` branch, the `.github/workflows/terraform.yml` workflow will pick it up and create the subnet `public_subnet_2` in AWS

# VPC management
- This module creates an AWS VPC, which is a logically isolated virtual network that you define within the AWS cloud. It allows you to launch AWS resources, such as EC2 instances and RDS databases, into a virtual network that you define. A VPC provides several benefits, including control over your virtual networking environment, customizable IP address ranges, and configuration of route tables and network gateways. With AWS VPC, you can create subnets, configure security groups and network ACLs, and establish VPN connections to extend your corporate network into the cloud securely.
- For example, to create a `dev` VPC:
  - Navigate to `subnet_management/terraform/main.tf` and add a module called `dev_vpc_creation`
  - Set the `source` variable to `git@github.com:ianforrest11/terraform_templates.git//aws/vpc_vpc?ref=main`
  - Define required variables `cidr_block`, `instance_tenancy`, & `name` like `var.ENVNAME_vpc_VARIABLENAME`
  - See the example below:
```
module "dev_vpc_creation" {
  source           = "git@github.com:ianforrest11/terraform_templates.git//aws/vpc_vpc?ref=main"
  cidr_block       = var.dev_vpc_cidr_block
  instance_tenancy = var.dev_vpc_instance_tenancy
  name             = var.dev_vpc_name
}
```
- Second, navigate to `vpc_management/variables/terraform.tfvars` and add variables for every `var.` parameter used above.  Determining `cidr_block` is outside the scope of this project. For example:
```
dev_vpc_cidr_block       = "10.1.0.0/16"
dev_vpc_instance_tenancy = "default"
dev_vpc_name             = "dev_vpc"
```
- Third, navigate to the `vpc_management/terraform/variables.tf` file and add placeholder variables to recognize the variables we added in the previous step.  They can be as simple as one line: 
```
variable "dev_vpc_cidr_block" {}
variable "dev_vpc_instance_tenancy" {}
variable "dev_vpc_name" {}
```
- Optional: if you'd like this VPC to be available to associate to other resources, navigate to the resource subdirectory's `data.tf` file `subnet_management/terraform/data.tf` and add a terraform `data` resource for the new VPC
```
data "aws_vpc" "dev_vpc" {
  filter {
    name   = "tag:Name"
    values = ["dev_vpc"]
  }
}
```
- once this updated configuration is pushed to the `main` branch, the `.github/workflows/terraform.yml` workflow will pick it up and create VPC `dev_vpc` in AWS