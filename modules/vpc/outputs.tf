output "firewall_rules" {
  value = {
    internal_rule  = google_compute_firewall.allow_internal.name
    external_rule  = google_compute_firewall.allow_external.name
  }
}

output "vpc_network_name" {
  value = google_compute_network.vpc_network.name
}

output "subnetwork_name" {
  value = google_compute_subnetwork.subnetwork.name
}