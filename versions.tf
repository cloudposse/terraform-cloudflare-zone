terraform {
  required_version = ">= 0.13"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 3.23"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.8"
    }
  }
}
