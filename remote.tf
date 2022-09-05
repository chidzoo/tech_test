terraform {
  backend "s3" {
    bucket = "terraform-rugbaja"
    key    = "terraform.tfstate"
    region = "eu-west-1"
    access_key = var.access_key
    secret_key = var.secret_key
  }
}