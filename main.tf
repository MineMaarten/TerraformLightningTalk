provider "azurerm" {
  version = "=2.18.0"
  features {}
}

terraform {
  backend "azurerm" {
    container_name       = "tfstate"
    key                  = "website"
  }
}

resource "azurerm_resource_group" "site" {
  name     = "rg-${var.site_name}-${var.stage}"
  location = "westeurope"
}

resource "azurerm_app_service_plan" "server" {
  name                = "hp-${var.site_name}-${var.stage}"
  location            = azurerm_resource_group.site.location
  resource_group_name = azurerm_resource_group.site.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "example" {
  name                = "as-${var.site_name}-${var.stage}"
  location            = azurerm_resource_group.site.location
  resource_group_name = azurerm_resource_group.site.name
  app_service_plan_id = azurerm_app_service_plan.server.id

  app_settings = {
    "SOME_KEY" = "some-value",
    "SOME_KEY2" = "some-value2"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}