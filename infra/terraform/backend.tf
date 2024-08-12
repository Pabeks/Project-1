terraform {
  backend "s3" {
    bucket = "paje-terraform"
    key    = "infra"
    region = "us-east-1"
  }
}


