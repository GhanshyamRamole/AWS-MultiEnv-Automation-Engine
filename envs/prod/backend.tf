terraform {
  backend "s3" {
    bucket       = "prod-bucket-automation-engine"
    key          = "DevOps/prod/terraform.tfstate"
    region       = "us-west-1"
    encrypt      = true
    use_lockfile = true
    
  }
}
