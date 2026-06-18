unit "module_1" {
  source = "git::https://github.com/Steve-CrateDefense/terragrunt-stack-filter-example.git//terraform-modules/module_1?ref=main"
  path = "module_1"
}

unit "module_2" {
  source = "git::https://github.com/Steve-CrateDefense/terragrunt-stack-filter-example.git//terraform-modules/module_2?ref=main"
  path = "module_2"
}
