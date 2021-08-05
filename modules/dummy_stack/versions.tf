terraform {
  required_version = "~> 0.14.8"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 2.1"
    }
  }
}
