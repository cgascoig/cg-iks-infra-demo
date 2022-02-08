terraform {
  required_providers {
    intersight = {
      source = "CiscoDevNet/intersight"
      # version = "1.0.22"
    }
  }
}
provider "intersight" {
  apikey    = var.intersight_api_key
  secretkey = var.intersight_secretkey
  endpoint  = var.intersight_endpoint
}
