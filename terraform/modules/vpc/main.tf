# vpc.tf
resource "google_compute_firewall" "firewall_ssh" {
  name    = "default-allow-ssh"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
 source_ranges = var.source_ranges
}

resource "google_compute_firewall" "firewall_web" {
  name    = "allow-web"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
source_tags = ["web"] 
source_ranges = var.source_ranges
}
