terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

//fgfgdgkfdlk

provider "aws" {
  region     = "ap-northeast-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}