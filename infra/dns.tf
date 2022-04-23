resource "azurerm_private_dns_zone" "dns_private" {
  name                = local.dns_private.name
  resource_group_name = local.dns_private.resource_group_name
  depends_on = [
      azurerm_resource_group.default
  ]
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_private_vnet_link" {
  for_each              = var.vnet
  name                  = "${each.key}vnetlink"
  resource_group_name   = local.dns_private.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dns_private.name
  virtual_network_id    = azurerm_virtual_network.vnet[each.key].id
  depends_on = [
    azurerm_private_dns_zone.dns_private
  ]
}