terraform {
  backend "s3" {
    bucket = "SEU-BUCKET-AQUI"  # ⚠️ SUBSTITUA pelo nome do seu bucket S3
    key    = "EKS/terraform.tfstate"
    region = "us-east-1"  # ⚠️ SUBSTITUA pela região onde criou o bucket
  }
}
