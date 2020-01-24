resource "google_compute_network" "ndcdemo-network" {
  name                    = "ndcdemo"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "ndcdemo-subnetwork-subnet1" {
  name                     = "ndcdemo-subnet1"
  ip_cidr_range            = "10.0.0.0/24"
  network                  = "${google_compute_network.ndcdemo-network.self_link}"
  region                   = "us-central1"
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "ndcdemo-subnetwork-subnet2" {
  name                     = "ndcdemo-subnet2"
  ip_cidr_range            = "10.1.0.0/24"
  network                  = "${google_compute_network.ndcdemo-network.self_link}"
  region                   = "us-central1"
  private_ip_google_access = true
}
