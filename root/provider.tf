terraform {
  backend "s3" {
    bucket = "okletsgo"
    key    = "development.terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.85"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}