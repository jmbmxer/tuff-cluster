resource "google_container_cluster" "ndcdemo-cluster" {
  provider                 = google-beta
  name                     = "ndcdemo"
  project                  = "jb0ss-terraform-admin"
  network                  = "ndcdemo"
  subnetwork               = "ndcdemo-subnet1"
  remove_default_node_pool = "true"
  initial_node_count       = "1"
  enable_shielded_nodes    = "true"


  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "allow"
    }
  }
  pod_security_policy_config {
    enabled = true
  }

  database_encryption {
    state    = "ENCRYPTED"
    key_name = google_kms_crypto_key.my_crypto_key.self_link
  }

  private_cluster_config {
    enable_private_nodes    = "true"
    enable_private_endpoint = "false"
    master_ipv4_cidr_block  = "192.168.0.0/28"
  }
  ip_allocation_policy {
    cluster_ipv4_cidr_block = null
    cluster_secondary_range_name = null
    subnetwork_name = null
    services_ipv4_cidr_block = null
  }
  addons_config {
    istio_config {
      disabled = false
    }
  }
}

resource "google_kms_key_ring" "test" {
  provider   = google
  project    = "jb0ss-terraform-admin"
  name     = "test"
  location = "global"
  #depends_on = ["google_project_services.jb0ss-terraform-admin"]
}

resource "google_kms_crypto_key" "my_crypto_key" {
  provider = google
  name     = "my-crypto-key"
  key_ring = google_kms_key_ring.test.self_link
}

data "google_iam_policy" "admin" {
  binding {
    role = "roles/editor"

    members = [
      "serviceAccount:ndc-terraform@jb0ss-terraform-admin.iam.gserviceaccount.com",
    ]
  }
}

resource "google_kms_key_ring_iam_policy" "key_ring" {
  key_ring_id = google_kms_key_ring.test.id
  policy_data = data.google_iam_policy.admin.policy_data
}