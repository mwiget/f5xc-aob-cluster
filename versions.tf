terraform {
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = ">= 0.11.23"
    }
    local = {
      source = "hashicorp/local"
      version = "2.4.0"
    }
    restapi = {
      source = "Mastercard/restapi"
      version = "1.18.2"
    }
  }
}

