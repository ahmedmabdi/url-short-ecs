terraform {
  backend "s3" {
    bucket       = "urlshortecs"
    key          = "global/terraform.tfstate"  
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"
}
