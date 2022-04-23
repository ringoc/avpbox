# resource "null_resource" "debug" {
#   triggers = {
#     # vnets   = jsonencode(local.vnets)
#     subnets = jsonencode(local.subnets)

#     # vm_ids = jsonencode(
#     #   [
#     #     for vm in azurerm_linux_virtual_machine.vm : vm
#     #     # {
#     #     #   "vm_name" = vm.name
#     #     #   "vm_id" = vm.id
#     #     #   "vm_public_ip" = vm.public_ip_address
#     #     # }
#     #   ]
#     # )
#   }
# }