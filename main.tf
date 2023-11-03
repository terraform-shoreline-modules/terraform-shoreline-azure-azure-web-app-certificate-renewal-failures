terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "azure_webapp_certificate_renewal_failures" {
  source    = "./modules/azure_webapp_certificate_renewal_failures"

  providers = {
    shoreline = shoreline
  }
}