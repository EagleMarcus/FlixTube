# Your Solution
#
# Creates a managed Kubernetes cluster on Azure.
#
resource "azurerm_kubernetes_cluster" "clusterAssignment8" {
    name                = var.app_name
    location            = var.location
    resource_group_name = azurerm_resource_group.FlixTube.name
    dns_prefix          = var.app_name
    kubernetes_version  = var.kubernetes_version

    default_node_pool {
        name            = "default"
        node_count      = 2
        vm_size         = "Standard_DS2_v2"
    }

    #
    # Instead of creating a service principle have the system figure this out.
    #
    identity {
        type = "SystemAssigned"
    }    
}

#
# Attaches the container registry to the cluster.
# See example here: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry#example-usage-attaching-a-container-registry-to-a-kubernetes-cluster
#
resource "azurerm_role_assignment" "role_assignment" {
  principal_id                     = azurerm_kubernetes_cluster.clusterAssignment8.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.container_registry.id
  skip_service_principal_aad_check = true
}

#
# Role assignment for the Kubernetes cluster to access the Azure Blob Storage.
#
resource "azurerm_role_assignment" "storage_role_assignment" {
  principal_id                     = azurerm_kubernetes_cluster.clusterAssignment8.kubelet_identity[0].object_id
  role_definition_name             = "Storage Blob Data Contributor"  # or "Storage Blob Data Owner"
  scope                            = azurerm_storage_account.blob_storage.id
  skip_service_principal_aad_check = true
}