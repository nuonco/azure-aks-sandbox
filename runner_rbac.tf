# The cluster runs with local accounts disabled and Azure AD RBAC, so every
# Kubernetes API call needs an Azure "AKS RBAC ..." role assignment. Component
# deploys authenticate as the per-operation managed identities (granted AKS RBAC
# in the app's permissions config), but the Nuon runner also talks to the cluster
# directly under its own system-assigned identity to sync secrets and images
# before any per-op identity is used. Nothing else grants that identity cluster
# access, so without this the runner can't create the app namespace on first sync.
#
# The runner VMSS is created by the Nuon install stack as "<nuon_id>-vmss" in the
# install resource group, so we look it up and grant its system identity the
# data-plane role. Cluster Admin (not Writer/Admin) is required because secret
# sync creates cluster-scoped namespaces.
data "azurerm_virtual_machine_scale_set" "runner" {
  count               = var.grant_runner_cluster_admin ? 1 : 0
  name                = "${var.nuon_id}-vmss"
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "runner_cluster_admin" {
  count                = var.grant_runner_cluster_admin ? 1 : 0
  scope                = module.aks.aks_id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = data.azurerm_virtual_machine_scale_set.runner[0].identity[0].principal_id
}
