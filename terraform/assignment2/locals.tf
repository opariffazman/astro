locals {
  project_name = "astro"
  managed_by   = "terraform"

  tags = { Environment = "assignment2", Project = local.project_name, ManagedBy = local.managed_by }
}
