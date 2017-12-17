# Setup:
# This is ridiculous.
#
# Find your org id && billing account ids
# gcloud organizations list && gcloud beta billing accounts list
# export CREDS=~/.config/gcloud/terraform.js
# export OID=<copy/paste an org id>
# export AID=<copy/paste an account id>
# export PROJECT=terraform-kwm-<something-custom>
# export GOOGLE_CREDENTIALS=$(cat ${CREDS})
# export GOOGLE_PROJECT=${PROJECT}
# gcloud projects create ${PROJECT} --organization ${OID} --set-as-default
# gcloud beta billing projects link ${PROJECT} --billing-account ${AID}
# gcloud iam service-accounts create terraform --display-name "Terraform Admin"
# gcloud iam service-accounts keys create ${CREDS} --iam-account terraform@${PROJECT}.iam.gserviceaccount.com
# gcloud projects add-iam-policy-binding ${PROJECT} --member serviceAccount:terraform@${PROJECT}.iam.gserviceaccount.com --role roles/viewer
# gcloud projects add-iam-policy-binding ${PROJECT} --member serviceAccount:terraform@${PROJECT}.iam.gserviceaccount.com --role roles/storage.admin
# gcloud services enable cloudresourcemanager.googleapis.com
# gcloud services enable compute.googleapis.com
# gcloud services enable cloudbilling.googleapis.com
# gcloud services enable iam.googleapis.com
# gcloud organizations add-iam-policy-binding ${OID} --member serviceAccount:terraform@${PROJECT}.iam.gserviceaccount.com --role roles/resourcemanager.projectCreator
# gcloud organizations add-iam-policy-binding ${OID} --member serviceAccount:terraform@${PROJECT}.iam.gserviceaccount.com --role roles/billing.user
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
  controller_count = 1
  node_count = 2
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
