terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"

  backend "s3" {
    bucket         = "iforrest-aws-s3-terraform-state"
    key            = "shared/vpc/internet_gateways"
    region         = "us-east-1"
    dynamodb_table = "iforrest-aws-dynamodb-terraform-state"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}