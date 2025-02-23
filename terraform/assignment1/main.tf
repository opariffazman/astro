provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.88.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket         = "assignment1-state-881490090314"
    key            = "assignment1.tfstate"
    region         = "us-east-1"
    dynamodb_table = "assignment1-state-lock"
    encrypt        = true
  }
}
