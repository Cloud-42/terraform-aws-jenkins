
terraform {
  required_version = ">= 0.13.2"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    template = {
      source = "hashicorp/template"
    }
  }
}
