terraform {
  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = "2.23.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.20.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform"
    storage_account_name = "itgostatefiles"
    container_name       = "terraform-state-files"
    key                  = "vultr-swarm.tfstate"
    use_azuread_auth     = true
  }
}

# Configure the Azure Provider
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Configure the Vultr Provider
provider "vultr" {
  api_key     = data.azurerm_key_vault_secret.VultrAPI_Secret.value
  rate_limit  = 100
  retry_limit = 3
}