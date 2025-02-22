variable "aws_account_id" {
  default = "881490090314"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "astro"
}

variable "tags" {
  default = {
    Project     = "astro"
    Environment = "dev"
    Terraform   = "true"
    Owner       = "ariff.azman"
  }
}