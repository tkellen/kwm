provider "google" {
  region = "us-central1"
}

resource "random_id" "id" {
  byte_length = 4
}

data "google_compute_zones" "available" {}

locals {
  name = "gcp"
  cidr = "10.100.0.0/16"
  etcd_count = 1
  controlplane_count = 1
  worker_count = 2
  subnetCidrs = [
    "${cidrsubnet(local.cidr, 8, 0)}",
    "${cidrsubnet(local.cidr, 8, 1)}",
    "${cidrsubnet(local.cidr, 8, 2)}"
  ]
}

resource "google_project" "kwm" {
  name = "Kubernetes Without Magic"
  project_id = "${random_id.id.hex}"
  org_id = "398631914792"
}
