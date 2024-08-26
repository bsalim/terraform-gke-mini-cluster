resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = "gke-subnetwork"
  network       = google_compute_network.vpc_network.id
  region = var.region
  ip_cidr_range  = var.ip_cidr_range

  private_ip_google_access = true  # Enable private Google access
}

resource "google_compute_firewall" "allow_internal" {
  name    = "allow-internal"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  allow {
    protocol = "icmp"  # Allow ICMP for ping within internal network
  }

  source_ranges = var.ip_cidr_range_list
}


resource "google_compute_firewall" "allow_external" {
  name    = "allow-external"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]  # Allow HTTP and HTTPS from external sources
  }

  # Change this accordingly if you want to open for public access / specific IPs
  source_ranges = ["0.0.0.0/0"]
}

# ICMP (Ping) Firewall Rule - Internal Only
resource "google_compute_firewall" "allow_internal_icmp" {
  name    = "allow-internal-icmp"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"  # Allow ICMP for internal network pinging
  }

  log_config {
    metadata = "EXCLUDE_ALL_METADATA"
  }

  source_ranges = var.ip_cidr_range_list  # Restrict ICMP traffic to the specific subnet
}