locals {
  resource_suffix           = [lower(var.resource_name), "euw", random_id.resource_group_name_suffix.hex]
  resource_suffix_kebabcase = join("-", local.resource_suffix)

  tags = {}
}
