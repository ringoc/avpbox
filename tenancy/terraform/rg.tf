
resource "azurerm_resource_group" "default" {
  name = "${var.prefix}tfstorage"
  location = var.location
}
