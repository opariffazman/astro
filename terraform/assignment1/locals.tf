variable "db_password" {
  default   = ""
  type      = string
  sensitive = false
}

locals {
  project_name  = "astro"
  managed_by    = "terraform"
  email_address = "ariff.tall814@passmail.net"

  vpc_cidr         = "10.0.0.0/16"
  private_subnets  = ["10.0.10.0/24", "10.0.20.0/24"]
  public_subnets   = ["10.0.101.0/24", "10.0.102.0/24"]
  database_subnets = ["10.0.201.0/24", "10.0.202.0/24"]

  instance_type     = "t2.micro"
  db_instance_type  = "db.t3.micro"
  nat_instance_type = "t3.nano"

  zone_name = "${local.project_name}.opariffazman.com"

  app_port = 8080
  app_name = "app"
  web_port = 80
  web_name = "web"

  db_port     = 3306
  db_username = "admin"
  db_password = var.db_password

  app_policies = [
    "arn:aws:iam::aws:policy/AmazonRDSFullAccess",
    "arn:aws:iam::aws:policy/CloudWatchFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  web_policies = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  ssm_services = {
    "ec2messages" : {
      "name" : "com.amazonaws.${local.region}.ec2messages"
    },
    "ssm" : {
      "name" : "com.amazonaws.${local.region}.ssm"
    },
    "ssmmessages" : {
      "name" : "com.amazonaws.${local.region}.ssmmessages"
    }
  }

  region = "us-east-1"
  tags   = { Environment = "assignment1", Project = local.project_name, ManagedBy = local.managed_by }
}
