locals {
  github_repo_name = "opariffazman/astro"
  project_name     = "astro"
  managed_by       = "terraform"

  tags = { Environment = "assignment3", Project = local.project_name, ManagedBy = local.managed_by }
}
