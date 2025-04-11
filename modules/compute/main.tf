# Create swarm instances
resource "vultr_instance" "docker-host01" {
  label    = "docker-host01"
  plan     = "vhf-1c-1gb"
  region   = "mel"
  image_id = "docker"
  hostname = "docker-host01"
  user_data = templatefile("${path.module}/docker-compose/cloud-init-compose.sh", {
    vaultwarden_admin_token = data.azurerm_key_vault_secret.Bitwarden_ADMIN_Secret.value
    tailscale_auth_key      = data.azurerm_key_vault_secret.Tailscale_Auth_Key.value
    ssh_pub_key             = data.azurerm_key_vault_secret.itgo_3080_ssh_key.value
  })
  ddos_protection  = true
  activation_email = true
}
