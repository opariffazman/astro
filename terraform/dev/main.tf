terraform {
  backend "s3" {
    bucket         = "terraform-state-881490090314"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
