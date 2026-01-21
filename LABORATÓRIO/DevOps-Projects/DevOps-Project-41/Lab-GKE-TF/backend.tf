# state.tf
terraform {
  backend "s3" {
    bucket = "bucket-lab-devops-41" 
    key    = "terraform.tfstate"
    region = ""
    profile= "default"
    prefix = "lab-devops-41"
  }
}
