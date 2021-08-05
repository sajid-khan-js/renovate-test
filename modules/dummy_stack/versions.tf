terraform {
  required_version = "~> 0.14.4"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 2.3"
    }
  }
}
