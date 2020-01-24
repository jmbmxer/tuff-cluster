provider "google" {
  credentials = "${file("../credentials/account.json")}"
  project     = "jb0ss-terraform-admin"
  region      = "us-west1"
}
