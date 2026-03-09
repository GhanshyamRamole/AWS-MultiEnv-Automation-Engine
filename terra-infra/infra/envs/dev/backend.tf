terraform {
  backend "s3" {
    bucket       = "dev-bucket-automation-engine"
    key          = "DevOps/dev/terraform.tfstate"
    region       = "us-west-1"
    encrypt      = true
    use_lockfile = true 
    
  }
}
