terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# All envs deploy resource group
module "rg" {
  source   = "./modules/rg"
  name     = "${var.environment}-rg"
  location = var.location
}

# Conditionally deploy storage account only if deploy_storage_account == true
module "storage_account" {
  source              = "./modules/storage_account"
  count               = var.deploy_storage_account ? 1 : 0
  name                = "${var.environment}storage"
  resource_group_name = module.rg.resource_group_name
  location            = var.location
}
