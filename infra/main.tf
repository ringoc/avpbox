terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tenancytfstorage"
    storage_account_name = "tenancytfsa"
    container_name       = "tenancytfcontainer"
    key                  = "dev.infra.terraform.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {
  }
}

# Create a resource group
resource "azurerm_resource_group" "default" {
  for_each = local.rg
  name     = each.value.name
  location = each.value.location
}

data "azurerm_key_vault" "default" {
  name                = "tenancykv"
  resource_group_name = "tenancytfstorage"
}
data "azurerm_key_vault_secret" "default" {
  name      = "vmpassword"
  key_vault_id = data.azurerm_key_vault.default.id
}