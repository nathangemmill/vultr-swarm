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
    key                  = "terraform.tfstate"
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

# Create swarm instances
resource "vultr_instance" "docker-swarm1" {
  label            = "docker-swarm1"
  plan             = "vhf-1c-1gb"
  region           = "syd"
  image_id         = "docker"
  hostname         = "docker-swarm1"
  ddos_protection  = true
  activation_email = true
}

resource "vultr_instance" "docker-swarm2" {
  label            = "docker-swarm2"
  plan             = "vhf-1c-1gb"
  region           = "syd"
  image_id         = "docker"
  hostname         = "docker-swarm2"
  ddos_protection  = true
  activation_email = true
}

resource "vultr_block_storage" "swarm1-block" {
  label                = "swarm1-block"
  size_gb              = 40
  region               = "syd"
  attached_to_instance = vultr_instance.docker-swarm1.id
}

resource "vultr_block_storage" "swarm2-block" {
  label                = "swarm2-block"
  size_gb              = 40
  region               = "syd"
  attached_to_instance = vultr_instance.docker-swarm2.id
}
