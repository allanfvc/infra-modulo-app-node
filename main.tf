# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region  = var.region
  profile = "gcs-user"
}

resource "aws_iam_instance_profile" "gcs_role_profile" {
  name  = "gcs_role_profile"
  role = "gcs_role"
}

module "db_instance" {
  source = "./modules/server"
  ami = var.ami[var.region]
  tipo_instancia = var.db_instance_type
  subnet_id = aws_subnet.private_subnet_1a.id
  security_groups_ids = [aws_security_group.psql_sg.id]
  inst_profile = aws_iam_instance_profile.gcs_role_profile.name
  user_data = templatefile("${path.module}/scripts/provisioning_db.sh.tpl", { db_name = var.db_name, db_user = var.db_user, db_password = var.db_password, app_network="10.0.1.0/24"})
  tags = {
    Name = "db"
  }
}

module "app_instance" {
  source = "./modules/server"
  ami = var.ami[var.region]
  tipo_instancia = var.app_instance_type
  subnet_id = aws_subnet.public_subnet_1a.id
  security_groups_ids = [aws_security_group.app_sg.id]
  inst_profile = aws_iam_instance_profile.gcs_role_profile.name
  user_data = templatefile("${path.module}/scripts/provisioning_app.sh.tpl", { db_name = var.db_name, db_user = var.db_user, db_password = var.db_password, db_ip_addr = module.db_instance.ip_privado})
  tags = {
    Name = "app"
  }
}