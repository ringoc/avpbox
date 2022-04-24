terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {
  }
}

variable "location" {
  default = "australiaeast"
}

variable "prefix" {
  default = "tenancy"

}

