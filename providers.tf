provider "azurerm" {
  features {}
}

provider "azapi" {}

# The cluster runs with local accounts disabled + Azure AD RBAC, so there is no
# static kubeconfig token to hand this provider (unlike GKE, where a Google
# access token works directly). Authenticate with kubelogin in managed-identity
# mode instead -- the same tool and AKS AAD server-id the Nuon runner uses. When
# kubelogin_client_id is set, the token is minted for that user-assigned identity
# (e.g. the per-operation provision identity, which already holds AKS RBAC from
# the install stack); left empty, kubelogin falls back to the VMSS
# system-assigned identity (see runner_rbac.tf for its grant).
provider "kubectl" {
  load_config_file       = false
  host                   = module.aks.host
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "kubelogin"
    args = concat(
      ["get-token", "--login", "msi", "--server-id", "6dae42f8-4368-4678-94ff-3960e28e3630"],
      var.kubelogin_client_id != "" ? ["--client-id", var.kubelogin_client_id] : [],
    )
  }
}
