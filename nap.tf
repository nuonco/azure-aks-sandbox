# Node Auto Provisioning (NAP) with Karpenter
#
# NAP is enabled via azapi_update_resource because the Azure/aks/azurerm module
# does not yet expose nodeProvisioningProfile natively.

resource "azapi_update_resource" "nap" {
  count = var.enable_nap ? 1 : 0

  type                    = "Microsoft.ContainerService/managedClusters@2025-05-01"
  resource_id             = module.aks.aks_id
  ignore_missing_property = true

  body = {
    properties = {
      nodeProvisioningProfile = {
        mode = "Auto"
      }
    }
  }

  depends_on = [module.aks]
}
