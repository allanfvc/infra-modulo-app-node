data "archive_file" "app" {
  type        = "zip"
  output_path = "${path.module}/files/app.zip"
  source_dir  = var.app_src_dir
}

resource "aws_s3_bucket_object" "upload" {
  bucket = "allanfvc"
  key    = "files/app.zip"
  source = "${path.module}/files/app.zip"
  tags = {
      Name = "app files"
  }
}