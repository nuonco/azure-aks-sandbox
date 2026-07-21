# Create the default namespaces up front, mirroring the AWS and GCP sandboxes.
# App components deploy into these (and some apps run a pre-deploy secret action
# that writes into a component namespace before the component's Helm release
# creates it), so the namespace must exist before the first deploy rather than
# being created lazily by Helm.
#
# Uses kubectl_manifest (gavinbunney) rather than kubernetes_namespace_v1
# (hashicorp) for the same reason GCP does: the hashicorp provider blocks on
# namespace deletion until the namespace fully terminates, which can hang
# teardown when a namespace holds workloads with controller-managed finalizers.
# kubectl_manifest does not block, so the namespace is reaped with the cluster.
locals {
  namespaces = toset(concat([var.nuon_id], var.additional_namespaces))
}

resource "kubectl_manifest" "namespaces" {
  for_each = local.namespaces

  yaml_body = yamlencode({
    apiVersion = "v1"
    kind       = "Namespace"
    metadata = {
      name = each.value
    }
  })

  depends_on = [module.aks, azurerm_role_assignment.runner_cluster_admin]
}
