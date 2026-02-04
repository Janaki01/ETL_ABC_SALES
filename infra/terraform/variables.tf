variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "env" {
  type    = string
  default = "sales"
}

variable "db_name" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_master_password" {
  type      = string
  sensitive = true
}

variable "s3_bucket_name" {
  type = string
}

variable "alert_email" {
  type = string
}
 