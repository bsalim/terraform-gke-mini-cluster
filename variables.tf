variable "credentials_file" {
  description = "Path to the service account key file."
  type        = string
}

variable "region" {
    description = "Region of the GKE cluster to be setup"
    type        = string
}

variable "project_id" {
    description = "Project id"
    type        = string
}

variable "vpc_name" {}
variable "gke_cluster_name" {}
variable "ip_cidr_range" {}
variable "ip_cidr_range_list" {}