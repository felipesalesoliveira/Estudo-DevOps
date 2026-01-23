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