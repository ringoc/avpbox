variable "vm_username" {
  default = "azureuser"
  sensitive = true
}

variable "vnet" {
  default = {
    coreservice = {
      name          = "coreservicehubvnet"
      location      = "eastus"
      type          = "hub"
      address_space = ["10.20.0.0/16"]
      peering       = ["manufacturing"]
      subnet = {
        gatewaysubnet = {
          name           = "gatewaysubnet"
          address_prefix = "10.20.0.0/27"
          include_vm     = false
          os_type        = "windows"
          vm_name = null
        }
#        sharedservicesubnet = {
#          name           = "sharedservicesubnet"
#          address_prefix = "10.20.10.0/24"
#          include_vm     = false
#          os_type        = "windows"
#          vm_name = null
#        }
#        adsubnet = {
#          name           = "adsubnet"
#          address_prefix = "10.20.1.0/24"
#          include_vm     = false
#          os_type        = "windows"
#          vm_name = null
#        }
#        mgmtsubnet = {
#          name           = "mgmtsubnet"
#          address_prefix = "10.20.99.0/24"
#          include_vm     = true
#          os_type        = "windows"
#          vm_name = "jumphost"
#        }
#        databasesubnet = {
#          name           = "databasesubnet"
#          address_prefix = "10.20.20.0/24"
#          include_vm     = false
#          os_type        = "windows"
#          vm_name = null
#        }
#        publicwebservicesubnet = {
#          name           = "publicwebservicesubnet"
#          address_prefix = "10.20.30.0/24"
#          include_vm     = false
#          os_type        = "windows"
#          vm_name = null
#        }
      }
    }
    manufacturing = {
      name          = "manufacturingspokevnet"
      location      = "westeurope"
      type          = "spoke"
      address_space = ["10.30.0.0/16"]
      peering       = ["coreservice"]
      subnet = {
        manufacturingsystemsubnet = {
          name           = "manufacturingsystemsubnet"
          address_prefix = "10.30.10.0/24"
          include_vm     = false
          os_type        = "linux"
          vm_name = "centos8"
        }
        sensorsubnet1 = {
          name           = "sensorsubnet1"
          address_prefix = "10.30.20.0/24"
          include_vm     = false
          os_type        = "windows"
          vm_name = null
        }
        sensorsubnet2 = {
          name           = "sensorsubnet2"
          address_prefix = "10.30.21.0/24"
          include_vm     = false
          os_type        = "windows"
          vm_name = null
        }
        sensorsubnet3 = {
          name           = "sensorsubnet3"
          address_prefix = "10.30.22.0/24"
          include_vm     = false
          os_type        = "windows"
          vm_name = null
        }
      }
    }
#    research = {
#      name          = "researchspokevnet"
#      location      = "australiaeast"
#      type          = "spoke"
#      address_space = ["10.40.0.0/16"]
#      peering       = []
#      subnet = {
#        researchsystemsubnet = {
#          vnet           = "research"
#          name           = "researchsystemsubnet"
#          address_prefix = "10.40.0.0/24"
#          include_vm     = false
#          os_type        = "windows"
#          vm_name = null
#        }
#      }
#    }
  }
}