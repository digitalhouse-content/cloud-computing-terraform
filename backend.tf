terraform {
  backend "s3" {
    encrypt = true
    bucket = "cloud2-terraform-tfstate"
    key    = "rickandmorty/terraform.tfstate"
    region = "us-east-1"
  }
}
