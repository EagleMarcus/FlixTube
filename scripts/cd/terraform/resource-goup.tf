# Your Solution
#
# Creates a resource group for FlixTube App in Azure account.
#
resource "azurerm_resource_group" "FlixTube" {
  name     = var.app_name
  location = var.location
}
