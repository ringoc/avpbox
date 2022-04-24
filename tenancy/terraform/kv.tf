data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "default" {
  location            = var.location
  name                = "${var.prefix}kv"
  resource_group_name = azurerm_resource_group.default.name
  sku_name            = "standard"
  tenant_id = data.azurerm_client_config.current.tenant_id
}

resource "azurerm_key_vault_access_policy" "default" {
  key_vault_id = azurerm_key_vault.default.id
  object_id    = data.azurerm_client_config.current.object_id
  tenant_id = data.azurerm_client_config.current.tenant_id

  key_permissions = [
    "Get",
    "Create"
  ]
  secret_permissions = [
    "Get",
    "List",
    "Set"
  ]
}

resource "azurerm_key_vault_secret" "default" {
  key_vault_id = azurerm_key_vault.default.id
  name         = "vmpassword"
  value        = "Password1234!"
}