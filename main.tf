# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region  = "sa-east-1"
  profile = "gcs-user"
}

module "db_instance" {
  source = "./modules/server"
  ami = var.ami["sa-east-1"]
  tipo_instancia = var.db_instance_type
  security_groups_ids = [aws_security_group.allow_ssh.id, aws_security_group.web_egress.id, aws_security_group.allow_postgresql.id]
  user_data = templatefile("./scripts/provisioning_db.sh.tpl", { db_name = var.db_name, db_user = var.db_user, db_password = var.db_password})
  tags = {
    Name = "db"
  }
}

module "app_instance" {
  source = "./modules/server"
  ami = var.ami[var.region]
  tipo_instancia = var.app_instance_type
  security_groups_ids = [aws_security_group.allow_ssh.id, aws_security_group.web_egress.id, aws_security_group.allow_http.id]
  user_data = templatefile("./scripts/provisioning_web.sh.tpl", { db_name = var.db_name, db_user = var.db_user, db_password = var.db_password})
  tags = {
    Name = "app"
  }
}