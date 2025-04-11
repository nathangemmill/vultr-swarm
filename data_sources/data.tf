data "azurerm_key_vault" "VultrAPI_Vault" {
  name                = "kv-itgo-tf-secrets"
  resource_group_name = "rg-terraform"
}

data "azurerm_key_vault_secret" "VultrAPI_Secret" {
  name         = "Vultr-API-Key"
  key_vault_id = data.azurerm_key_vault.VultrAPI_Vault.id
  timeouts {
    read = "1m"
  }
}

data "azurerm_key_vault_secret" "tfstate_Storage_Secret" {
  name         = "vultr-swarm-tfstate"
  key_vault_id = data.azurerm_key_vault.VultrAPI_Vault.id
  timeouts {
    read = "1m"
  }
}

data "azurerm_key_vault_secret" "Bitwarden_ADMIN_Secret" {
  name         = "Bitwarden-ADMIN-Secret"
  key_vault_id = data.azurerm_key_vault.VultrAPI_Vault.id
  timeouts {
    read = "1m"
  }
}

data "azurerm_key_vault_secret" "Tailscale_Auth_Key" {
  name         = "Tailscale-Auth-Key"
  key_vault_id = data.azurerm_key_vault.VultrAPI_Vault.id
  timeouts {
    read = "1m"
  }
}

data "azurerm_key_vault_secret" "itgo_3080_ssh_key" {
  name         = "itgo-3080-ssh-key"
  key_vault_id = data.azurerm_key_vault.VultrAPI_Vault.id
  timeouts {
    read = "1m"
  }
}