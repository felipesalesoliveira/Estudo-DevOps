###############################################################################
# AWS S3 Bucket
###############################################################################

resource "aws_s3_bucket" "bucket" {
  bucket = "name_bucket"

  tags = {
    Name        = "value"
    Environment = "value"
  }
}

###############################################################################
# AZURE BLOB STORAGE Bucket
###############################################################################

resource "azurerm_storage_account" "storage_account" {
  name                     = "nome_único_bucket"
  resource_group_name      = "nome_resource_group"
  location                 = "us-east-1"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

###############################################################################
# GOOGLE CLOUD STORAGE Bucket
###############################################################################

resource "google_storage_bucket" "bucket" {
  name     = "nome_único_bucket"
  location = "location-value"

  labels = {
    Name        = "value"
    Environment = "value"
  }
}