terraform {
  backend "s3" {
    bucket         = "terraform-lab3-statefile" 
    key            = "dev/terraform.tfstate" 
    region         = "us-east-1" 
  }
}