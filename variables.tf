variable "nuon_id" {
  type        = string
  description = "The nuon id for this install. Used for naming purposes."
}

variable "location" {
  type        = string
  description = "The location to launch the cluster in"
}

// NOTE: if you would like to create an internal load balancer, with TLS, you will have to use the public domain.
variable "internal_root_domain" {
  type        = string
  description = "The internal root domain."
}

variable "public_root_domain" {
  type        = string
  description = "The public root domain."
}

variable "cluster_version" {
  type        = string
  description = "The Kubernetes version to use for the AKS cluster."
  default     = "1.34"
}

variable "cluster_endpoint_public_access" {
  type        = string
  default     = "true"
  description = "Whether the AKS cluster's Kubernetes API server endpoint is publicly accessible. Accepts \"true\"/\"false\"; only \"false\" makes the cluster private (empty/unset defaults to public). String rather than bool so an unset optional install input renders cleanly instead of failing type validation."
}

variable "vm_size" {
  type        = string
  default     = "Standard_D2as_v6"
  description = "The image size."
}

variable "node_min_count" {
  type        = number
  default     = 1
  description = "Minimum number of nodes in the default node pool (autoscaling lower bound)."
}

variable "node_max_count" {
  type        = number
  default     = 3
  description = "Maximum number of nodes in the default node pool (autoscaling upper bound)."
}

variable "node_os_disk_size_gb" {
  type        = number
  default     = 100
  description = "OS disk size (GiB) for default node pool nodes."
}

variable "enable_nap" {
  type        = bool
  default     = false
  description = "Enable Node Auto Provisioning (NAP) with Karpenter. Requires Azure CNI Overlay networking. Mutually exclusive with cluster autoscaler on additional node pools."
}

variable "grant_runner_cluster_admin" {
  type        = bool
  default     = true
  description = "Grant the Nuon runner's system-assigned identity 'Azure Kubernetes Service RBAC Cluster Admin' on the cluster. Required with local_account_disabled + Azure AD RBAC (the default) so the runner can sync secrets/images before any per-operation identity is used. Set false for local-runner installs where no '<nuon_id>-vmss' scale set exists."
}

variable "additional_namespaces" {
  type        = list(string)
  default     = []
  description = "Extra namespaces to create in the cluster. The nuon_id namespace is always created. Mirrors the AWS/GCP sandboxes so app components (and their pre-deploy secret actions) can rely on their namespace existing before the first deploy."
}

variable "kubelogin_client_id" {
  type        = string
  default     = ""
  description = "Client ID of the user-assigned managed identity kubelogin should mint AKS tokens for when creating namespaces (msi mode). Set this to an identity that already holds AKS RBAC on the cluster (e.g. the install stack's provision identity) to avoid a role-assignment propagation race. Empty uses the VMSS system-assigned identity, which grant_runner_cluster_admin covers."
}

variable "vnet_name" {
  type        = string
  description = "The name of the existing Virtual Network created by Bicep."
}

variable "resource_group_name" {
  type        = string
  description = "The resource group name where the existing Virtual Network is located."
}

variable "private_subnet_names" {
  type        = string
  description = "The subnets to deploy private resources into."
}

variable "public_subnet_names" {
  type        = string
  description = "The subnets to deploy public resources into."
}

