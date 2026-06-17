terraform {
  backend "s3" {
    bucket = "piranesi-terraform-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

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
  region = var.region
}
