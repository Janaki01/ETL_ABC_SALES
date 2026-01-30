variable "region" {
    type = string
}
variable "db_name" {
    type =string
}
variable "db_user" {}
variable "db_master_password" {
    description = "RDS master password"
    type = string
    sensitive = true
}