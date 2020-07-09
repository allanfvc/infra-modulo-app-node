variable "ami" {
    type = map
    default = {
        "us-east-2" = "ami-07c1207a9d40bc3bd"
        "sa-east-1" = "ami-0faf2c48fc9c8f966"
    }
}

variable "region" {
  type = string
  default = "sa-east-1"
}

variable "project_name" {
  type = string
}
variable "db_name" {
  type = string
}
variable "db_user" {
  type = string
}
variable "db_password" {
  type = string
}

variable "db_instance_type" {
  type = string
  default = "t2.micro"
}

variable "app_instance_type" {
  type = string
  default = "t2.micro"
}
variable "app_src_dir" {
  type = string
}