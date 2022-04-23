resource "azurerm_storage_account" "sa" {
    for_each = var.vnet
    name                = "${each.key}sa"
    resource_group_name = each.key
    location            = each.value.location
    account_tier        = "Standard"
    account_replication_type =  "LRS"
    depends_on = [
      azurerm_resource_group.default
    ]
}