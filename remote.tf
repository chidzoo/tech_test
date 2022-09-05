terraform {
  backend "s3" {
    bucket = "terraform-rugbaja"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}