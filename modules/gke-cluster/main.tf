resource "google_container_cluster" "gke_cluster" {
  name               = var.cluster_name
  location           = var.region
  deletion_protection = false # for development purpose

  # Optional: Configure node pools with custom settings
  node_pool {
    name       = "default-node-pool"
    max_pods_per_node = 50 
    node_count = 1
    autoscaling {
        min_node_count = 1
        max_node_count = 2  # Keep it minimal for testing
    }
    node_config {
      machine_type      = var.machine_type  # e.g., "e2-small"
      disk_size_gb      = 50                # Adjust as needed
      preemptible       = true              # Use preemptible VMs for cost savings
      oauth_scopes      = [
        "https://www.googleapis.com/auth/cloud-platform"
      ]

      # Optional: Configure additional settings for cost optimization
      disk_type         = "pd-standard" # Use standard persistent disk for cost savings
      local_ssd_count   = 0             # No local SSDs
      min_cpu_platform  = "Automatic"   # Automatically select the best CPU platform
    }
  }

  network    = var.network
  subnetwork = var.subnetwork
}