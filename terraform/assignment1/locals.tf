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
  public_subnet_1  = "10.0.1.0/24"
  public_subnet_2  = "10.0.2.0/24"
  private_subnet_1 = "10.0.11.0/24"
  private_subnet_2 = "10.0.12.0/24"
  db_subnet_1      = "10.0.21.0/24"
  db_subnet_2      = "10.0.22.0/24"

  instance_type     = "t2.micro"
  db_instance_type  = "db.t3.micro"
  nat_instance_type = "t3.nano"

  zone_name = "${local.project_name}.opariffazman.com"

  app_port = 8080
  app_name = "app"
  web_port = 80
  web_name = "web"

  db_username = "admin"
  db_password = var.db_password

  region         = "us-east-1"
  ubuntu_version = "jammy-22.04"
  tags           = { Environment = "assignment1", Project = local.project_name, ManagedBy = local.managed_by }
}
