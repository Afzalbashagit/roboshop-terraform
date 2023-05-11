terraform {
  backend "s3" {
    bucket = "terraform-s3-72"
    key    = "roboshop/dev/terraform.tfstate"
    region = "us-east-1"
  }
}