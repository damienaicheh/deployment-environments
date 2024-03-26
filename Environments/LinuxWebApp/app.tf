resource "azurerm_service_plan" "this" {
  name                = format("asp-%s", local.resource_suffix_kebabcase)
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "this" {
  name                = format("app-%s", local.resource_suffix_kebabcase)
  resource_group_name = data.azurerm_resource_group.this.name
  location            = azurerm_service_plan.this.location
  service_plan_id     = azurerm_service_plan.this.id

  site_config {}

  tags = {
    "azd-service-name" = "api"
  }
}
