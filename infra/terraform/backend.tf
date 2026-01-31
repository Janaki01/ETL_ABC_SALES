terraform {
    backend "s3" {
        bucket = "etl-terraform-states"
        key = "etl/ ${var.env}/terraform.tfstate"
        region = "ap-south-1"
        encrypt = true
    }
}