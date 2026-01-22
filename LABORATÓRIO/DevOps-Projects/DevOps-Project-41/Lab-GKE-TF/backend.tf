# state.tf
terraform {
  backend "gcs" {
    bucket = "bucket-lab-devops-41"
    prefix = "lab-devops-41/terraform"
  }
}

