provider "azurerm" {
  features {}
}


terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.99.0"
    }

  }


backend "azurerm" {
   resource_group_name  = "backend-container"
   storage_account_name = "st2003"
   container_name       = "containe1"
   key                  = "azure/stg/terraform.tfstate"
 }
}
