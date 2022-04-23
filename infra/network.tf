locals {
#   vnets = { for k, v in azurerm_virtual_network.vnet : k => v }
  subnets = flatten([
     for vnet_key, vnet in azurerm_virtual_network.vnet : [
      for subnet in vnet.subnet : {
        name           = subnet.name
        id             = subnet.id
        address_prefix = subnet.address_prefix
        os_type        = var.vnet[vnet_key].subnet[subnet.name].os_type
        include_vm     = var.vnet[vnet_key].subnet[subnet.name].include_vm
        vm_name        = var.vnet[vnet_key].subnet[subnet.name].vm_name
        vnet           = vnet.name
        key            = vnet_key
        rg             = vnet.resource_group_name
        location       = vnet.location
      }
    ]
  ])
  peerings = flatten([
    for vnet_key, vnet in var.vnet : [
      for peer in vnet.peering: {
        key = vnet_key
        vnet = vnet.name
        peering = peer
      }
      if vnet.peering != null
    ] 
  ])
}

resource "azurerm_virtual_network" "vnet" {
  for_each            = var.vnet
  name                = each.value.name
  location            = each.value.location
  resource_group_name = azurerm_resource_group.default[each.key].name
  address_space       = each.value.address_space

  dynamic "subnet" {
    for_each = each.value.subnet
    content {
      name           = subnet.value.name
      address_prefix = subnet.value.address_prefix
      security_group = subnet.value.name != "gatewaysubnet" ? azurerm_network_security_group.nsg[each.key].id : null
    }
  }

  depends_on = [
    azurerm_resource_group.default
  ]
}

resource "azurerm_virtual_network_peering" "peering" {
  for_each = {
    for peer in local.peerings : "${peer.vnet}-${peer.peering}" => peer
    if peer.peering != null
  }
  name                      = "${each.value.vnet}-${each.value.peering}"
  resource_group_name       = azurerm_resource_group.default[each.value.key].name
  virtual_network_name      = each.value.vnet
  remote_virtual_network_id = azurerm_virtual_network.vnet[each.value.peering].id
}

resource "azurerm_network_security_group" "nsg" {
  # for_each = {
  #   for subnet in local.subnets : "${subnet.vnet}-${subnet.name}" => subnet
  #   if subnet.name != "GatewaySubnet" && local.is_provisioning_vm && subnet.include_vm
  # }
  for_each = azurerm_resource_group.default
  name                = "default-subnet-nsg"
  resource_group_name = each.value.name
  location            = each.value.location
  security_rule {
    name                       = "default-subnet-nsg-rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges = ["22","80","443","445","3389"]
    source_address_prefix      = "159.196.149.211/32"
    destination_address_prefix = "*"
  }
  
}