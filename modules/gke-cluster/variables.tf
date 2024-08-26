variable "cluster_name" {
  description = "GKE Cluster name"
  type        = string
}

variable "region" {
    description = "Region of the GKE cluster to be setup"
    type        = string
}

variable "network" {
  description = "The VPC network to deploy the GKE cluster in"
  type        = string
}

variable "subnetwork" {
  description = "The subnetwork to deploy the GKE cluster in"
  type        = string
}

variable "machine_type" {
  description = "The machine type for the GKE nodes"
  type        = string
  default     = "e2-small"  # Adjust as needed
}