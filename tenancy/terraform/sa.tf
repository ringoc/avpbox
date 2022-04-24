resource "azurerm_storage_account" "default" {
  account_tier             = "Standard"
  account_replication_type = "ZRS"
  location                 = var.location
  name                     = "${var.prefix}tfsa"
  resource_group_name      = azurerm_resource_group.default.name
}

resource "azurerm_storage_container" "default" {
  name                 = "${var.prefix}tfcontainer"
  storage_account_name = azurerm_storage_account.default.name
}
