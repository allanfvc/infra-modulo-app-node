resource "aws_instance" "server" {
    ami           = var.ami
    instance_type = var.tipo_instancia
    key_name = var.chave_ssh
    vpc_security_group_ids = var.security_groups_ids
    tags = var.tags
    user_data = var.user_data
}
