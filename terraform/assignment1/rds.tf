module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.10.0"

  identifier = "${local.project_name}-db"

  engine               = "mysql"
  engine_version       = "5.7"
  family               = "mysql5.7"
  major_engine_version = "5.7"
  instance_class       = "db.t3.micro"
  allocated_storage    = 5
  deletion_protection  = false

  db_name  = "${local.project_name}-db"
  username = local.db_username
  password = local.db_password
  port     = 3306

  iam_database_authentication_enabled = true
  multi_az                            = false
  db_subnet_group_name                = module.vpc.database_subnet_group_name
  vpc_security_group_ids              = [module.db_security_group.security_group_id]

  skip_final_snapshot = true
  monitoring_interval = 0
  publicly_accessible = false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  tags = local.tags
}
