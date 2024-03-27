terraform {
   required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.97.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {}

  skip_provider_registration = true
}


