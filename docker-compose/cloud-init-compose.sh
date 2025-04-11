#!/bin/bash
set -e

# Clone your repo
git clone --branch private-vaultwarden https://github.com/nathangemmill/vultr-swarm.git /tmp/docker-apps

# Go to the folder containing your compose files
cd /tmp/docker-apps/docker-compose

# Create .env with secrets
cat <<EOF > .env
VAULTWARDEN_ADMIN_TOKEN=${vaultwarden_admin_token}
TS_AUTHKEY=${tailscale_auth_key}
EOF

# Run each stack by name
docker-compose -f bitwarden-compose.yml up -d
docker-compose -f caddyv2-compose.yml up -d
docker-compose -f portainer-compose.yml up -d
#docker-compose -f tailscale-compose.yml up -d