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
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}