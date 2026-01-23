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