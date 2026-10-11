terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  # Set AWS_REGION in your shell or configure a named AWS CLI profile.
  # Do not hard-code credentials in Terraform files.
  region = var.aws_region
}
