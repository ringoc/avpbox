resource "azurerm_network_interface" "nic" {
  for_each = {
    for subnet in local.subnets : "${subnet.vnet}-${subnet.name}" => subnet
    if subnet.name != "GatewaySubnet" && local.is_provisioning_vm && subnet.include_vm
  }
  name                = each.value.vm_name
  location            = each.value.location
  resource_group_name = each.value.rg

  ip_configuration {
    name                          = "internal"
    subnet_id                     = each.value.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pubip[each.key].id
  }

  depends_on = [
    azurerm_public_ip.pubip
  ]
}

resource "azurerm_public_ip" "pubip" {
  for_each = {
    for subnet in local.subnets : "${subnet.vnet}-${subnet.name}" => subnet
    if subnet.name != "GatewaySubnet" && local.is_provisioning_vm && subnet.include_vm 
  }
  name                = each.value.vm_name
  resource_group_name = each.value.rg
  location            = each.value.location
  allocation_method   = "Static"
}

resource "azurerm_windows_virtual_machine" "vm" {
  for_each = {
    for subnet in local.subnets : "${subnet.vnet}-${subnet.name}" => subnet
    if subnet.name != "GatewaySubnet" && local.is_provisioning_vm && subnet.include_vm && subnet.os_type == "windows"
  }
  name                = each.value.vm_name
  resource_group_name = each.value.rg
  location            = each.value.location
  size                = "Standard_D2_v3"
  admin_username      = "azureuser"
  admin_password      = var.vm_password
  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id,
  ]

  # admin_ssh_key {
  #   username   = "azureuser"
  #   public_key = file("~/.ssh/id_rsa.pub")
  # }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = "https://${each.value.key}sa.blob.core.windows.net/" 
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "schedule" {
  for_each = {for k, v in azurerm_linux_virtual_machine.vm: k => v}
  virtual_machine_id = each.value.id  
  location           = each.value.location
  enabled            = true

  daily_recurrence_time = "1900"
  timezone              = "AUS Eastern Standard Time"

  notification_settings {
    enabled         = true
    email = "ringochan@microsoft.com"
  }
 }


resource "azurerm_linux_virtual_machine" "vm" {
  for_each = {
    for subnet in local.subnets : "${subnet.vnet}-${subnet.name}" => subnet
    if subnet.name != "GatewaySubnet" && local.is_provisioning_vm && subnet.include_vm && subnet.os_type == "linux"
  }
  name                = each.value.vm_name
  resource_group_name = each.value.rg
  location            = each.value.location
  size                = "Standard_D2_v3"
  admin_username      = "azureuser"
  admin_password      = var.vm_password
  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "8_4"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = "https://${each.value.key}sa.blob.core.windows.net/" 
  }
}



resource "azurerm_dev_test_global_vm_shutdown_schedule" "linux" {
  for_each = {for k, v in azurerm_linux_virtual_machine.vm: k => v}
  virtual_machine_id = each.value.id  
  location           = each.value.location
  enabled            = true

  daily_recurrence_time = "1900"
  timezone              = "AUS Eastern Standard Time"

  notification_settings {
    enabled         = true
    email = "ringochan@microsoft.com"
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "windows" {
  for_each = {for k, v in azurerm_windows_virtual_machine.vm: k => v}
  virtual_machine_id = each.value.id  
  location           = each.value.location
  enabled            = true

  daily_recurrence_time = "1900"
  timezone              = "AUS Eastern Standard Time"

  notification_settings {
    enabled         = true
    email = "ringochan@microsoft.com"
  }
}




# # output "virtual_machine_id" {

#   #   for_each = { 
#   #     for subnet in local.subnets: "${subnet.vnet}-${subnet.name}" => subnet
#   #     if subnet.name != "GatewaySubnet" && local.is_provisioning_vm
#   #   }
#   # sensitive = false
#   # value = jsonencode(
#   #   [
#   #     for vm in azurerm_linux_virtual_machine.vm :
#   #     {
#   #       "vm_name"      = vm.name
#   #       "vm_id"        = vm.id
#   #       "vm_public_ip" = vm.public_ip_address
#   #     }
#   #   ]
#   # )
# # }