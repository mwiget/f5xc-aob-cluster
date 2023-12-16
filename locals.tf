locals {
  cwd = split("/", path.cwd)
  terraform_folder = element(local.cwd, length(local.cwd) - 1)
}
