locals {
  is_provisioning_vm = false

  rg = {
    coreservice = {
      name     = "coreservice"
      location = "eastus"
    }
    manufacturing = {
      name     = "manufacturing"
      location = "westeurope"
    }
    research = {
      name     = "research"
      location = "australiaeast"
    }
  }

  dns_private = {
    name                = "private.azure.kumbora.com"
    resource_group_name = "coreservice"
    location            = "eastus"
  }
}
