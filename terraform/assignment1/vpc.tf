module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "${local.project_name}-vpc"
  cidr = local.vpc_cidr

  azs              = ["${local.region}a", "${local.region}b"]
  private_subnets  = [local.private_subnets[0], local.private_subnets[1]]
  public_subnets   = [local.public_subnets[0], local.public_subnets[1]]
  database_subnets = [local.database_subnets[0], local.database_subnets[1]]

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  create_database_subnet_group = true

  tags = local.tags
}

resource "aws_vpc_endpoint" "ssm_endpoint" {
  for_each            = local.ssm_services
  vpc_id              = module.vpc.vpc_id
  service_name        = each.value.name
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [module.ssm_security_group.security_group_id]
  private_dns_enabled = false
  ip_address_type     = "ipv4"
  subnet_ids          = module.vpc.private_subnets
}