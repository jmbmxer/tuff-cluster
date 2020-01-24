provider "google-beta" {
  credentials = "${file("../credentials/account.json")}"
  project     = "jb0ss-terraform-admin"
  region      = "us-central1"
  zone        = "us-central1-c"
}
