terraform {
  backend "s3" {
    bucket         = "devops-platform-accelerator-terraform-state-743676310994"
    key            = "epd/client-c/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "devops-platform-accelerator-terraform-locks"
  }
}
