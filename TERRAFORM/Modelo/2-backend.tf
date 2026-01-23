###############################################################################
# AWS S3 Backend
###############################################################################

terraform {
   
 backend "s3" {
    bucket = "felipesales-exemplo04"
    key    = "aws-nome/terraform.tfstate"
    region = "us-east-1"
  }
  
}

###############################################################################
# AZURE Backend
###############################################################################

terraform {

  backend "azurerm" {
    resource_group_name = "nome-resource-group"
    storage_account_name = "nome_storage_account"
    container_name       = "nome_container"
    key                  = "nome-terraform.tfstate"
  }

}

###############################################################################
# GCP Backend
###############################################################################

terraform {

  backend "gcs" {
    bucket = "nome_bucket"
    prefix = "nome-terraform.tfstate"
  }

}