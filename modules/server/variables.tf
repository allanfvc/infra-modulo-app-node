variable "ami" {
    type = string
    description = "ID da AMI a ser utilizada"
}
variable "tipo_instancia" {
    type = string
    description = "Tipo de instância EC2 do servidor"
    default = "t2.micro"
}
variable "chave_ssh" {
    type = string
    description = "Chave SSH utilizada para acesso remoto"
    default = "gcs-key"
}
variable "user_data" {
    type = string
    description = "Script para inicialização do servidor"
}
variable "security_groups_ids" {
    type = list
    description = "Lista dos IDs dos grupos de segurança para adicionar a máquina. Por padrão, já é adicionada nos grupos 'allow_ssh' e 'web_egress'"
}
variable "tags" {
    type = map
    description = "Tags a serem aplicadas na instância"
}

variable "subnet_id" {
  type = string
  description = "ID da subrede em que a instância será criada"
}