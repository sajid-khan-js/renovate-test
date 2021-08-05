terraform {
  required_version = "~> 1.0.0"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 2.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 2.1"
    }
  }
}
