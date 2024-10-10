#Creates a storage account for Blob Storage

resource "azurerm_storage_account" "blob_storage" {
  name                     = "${var.app_name}storage"  # Must be globally unique
  resource_group_name      = azurerm_resource_group.FlixTube.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Creates a blob container within the storage account
resource "azurerm_storage_container" "blob_container" {
  name                  = "videos"  # Name of the blob container
  storage_account_name  = azurerm_storage_account.blob_storage.name
  container_access_type = "private"  # Change to "public" if needed
}