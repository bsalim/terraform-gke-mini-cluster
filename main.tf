provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file(var.credentials_file)
}

module "vpc" {
  source  = "./modules/vpc"
  region = var.region
  vpc_name = var.vpc_name
  ip_cidr_range = var.ip_cidr_range
  ip_cidr_range_list = var.ip_cidr_range_list
}

module "gke_cluster" {
  source    = "./modules/gke-cluster"
  region    = var.region
  network   = module.vpc.vpc_network_name
  subnetwork = module.vpc.subnetwork_name
  cluster_name = var.gke_cluster_name
}