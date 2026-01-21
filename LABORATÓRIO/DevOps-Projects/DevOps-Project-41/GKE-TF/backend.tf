###############################################################################
# Backend do Terraform (GCS - Google Cloud Storage)
###############################################################################

terraform {
  backend "gcs" {
    bucket = "SEU-BUCKET-GCS-AQUI"  # ⚠️ SUBSTITUA pelo nome do seu bucket GCS
    prefix = "gke/terraform.tfstate" # Prefixo para o arquivo de estado
  }
}

# NOTA: Se preferir usar backend local (sem GCS), comente o bloco acima
# e o Terraform usará backend local automaticamente
