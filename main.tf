# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region  = "sa-east-1"
  profile = "gcs-user"
}

data "archive_file" "app" {
  type        = "zip"
  output_path = "${path.module}/files/app.zip"
  source_dir  = var.app_src_dir
}

resource "aws_s3_bucket_object" "upload" {
  bucket = "allanfvc"
  key    = "files/app.zip"
  source = "${path.module}/files/app.zip"
  acl = "public-read"
  tags = {
      Name = "Aula Terraform"
  }
}

module "db_instance" {
  source = "./modules/server"
  ami = var.ami["sa-east-1"]
  tipo_instancia = var.db_instance_type
  subnet_id = aws_subnet.private_subnet_1a.id
  security_groups_ids = [aws_security_group.allow_ssh.id, aws_security_group.web_egress.id, aws_security_group.allow_postgresql.id]
  user_data = templatefile("${path.module}/scripts/provisioning_db.sh.tpl", { db_name = var.db_name, db_user = var.db_user, db_password = var.db_password})
  tags = {
    Name = "db"
  }
}

module "app_instance" {
  source = "./modules/server"
  ami = var.ami[var.region]
  tipo_instancia = var.app_instance_type
  subnet_id = aws_subnet.public_subnet_1a.id
  security_groups_ids = [aws_security_group.allow_ssh.id, aws_security_group.web_egress.id, aws_security_group.allow_http.id]
  user_data = templatefile("${path.module}/scripts/provisioning_app.sh.tpl", { db_name = var.db_name, db_user = var.db_user, db_password = var.db_password, db_ip_addr = module.db_instance.ip_privado})
  tags = {
    Name = "app"
  }
}