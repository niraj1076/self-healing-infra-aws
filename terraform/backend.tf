terraform {
  backend "s3" {
    bucket         = "self-healing-terraform-state-09999"
    key            = "project1/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
  }
}
