terraform {

  backend "remote" {
    organization = "smdevops96_org"

    workspaces {
      name = "aws_smdevops96_iac"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.33.0"
    }
  }
}