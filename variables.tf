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
  default     = "1.33"
}

variable "cluster_endpoint_public_access" {
  type        = bool
  default     = true
  description = "Whether the AKS cluster's Kubernetes API server endpoint is publicly accessible. When false, the cluster is created as a private cluster (system-managed private DNS zone); the API is then only reachable from inside the VNet, e.g. from the Nuon runner."
}

variable "vm_size" {
  type        = string
  default     = "Standard_D2s_v3"
  description = "The image size."
}

variable "node_count" {
  type        = number
  default     = 2
  description = "The minimum number of nodes in the managed node pool."
}

variable "enable_nap" {
  type        = bool
  default     = false
  description = "Enable Node Auto Provisioning (NAP) with Karpenter. Requires Azure CNI Overlay networking. Mutually exclusive with cluster autoscaler on additional node pools."
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

