terraform {
  backend "s3" {
    bucket = "paje-terraform"
    key    = "infra/tfstate"
    region = "us-east-1"
  }
}


