# resource "azurerm_route_table" "rt" {
#   name                          = "default-rt"
#   location                      = "eastus"
#   resource_group_name           = "coreservice"
#   disable_bgp_route_propagation = false

#   route {
#     name           = "route1"
#     address_prefix = "0.0.0.0/0"
#     next_hop_type  = "None"
#   }
# }
# resource "azurerm_subnet_route_table_association" "subnet_rt" {
#   subnet_id      = "/subscriptions/1a0efba5-8774-4b0c-a24b-d52b173af32e/resourceGroups/coreservice/providers/Microsoft.Network/virtualNetworks/coreservice/subnets/SharedServicesSubnet"
#   route_table_id = azurerm_route_table.rt.id
# }