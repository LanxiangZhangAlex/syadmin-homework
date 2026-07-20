# TODO create an S3 bucket.

#resource "aws_s3_bucket_object" "textfile" {
#  bucket                 = local.files_bucket
#  key                    = "textfile.txt"
#  content                = data.template_file.textfile.rendered
#  server_side_encryption = "AES256"
#}
resource "aws_s3_bucket" "file_bucket" {
  bucket_prefix = "${var.team}-${var.product}-files-"
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "file_bucket" {
  bucket = aws_s3_bucket.file_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "file_bucket" {
  bucket = aws_s3_bucket.file_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "file" {
  bucket = aws_s3_bucket.file_bucket.id
  key    = "example.txt"
  source = "${path.module}/files/example.txt"

  depends_on = [aws_s3_bucket_ownership_controls.file_bucket]
}
