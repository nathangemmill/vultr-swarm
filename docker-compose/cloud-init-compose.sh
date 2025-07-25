#!/bin/bash
set -e

# Create user if not exists
useradd -m -s /bin/bash nathangemmill || true

# Add SSH key
mkdir -p /home/nathangemmill/.ssh
echo "${ssh_pub_key}" > /home/nathangemmill/.ssh/authorized_keys
chown -R nathangemmill:nathangemmill /home/nathangemmill/.ssh
chmod 700 /home/nathangemmill/.ssh
chmod 600 /home/nathangemmill/.ssh/authorized_keys

# Disable root SSH login
sed -i 's/^#PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config

# Disable password authentication
#sed -i 's/^#PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config
#sed -i 's/^PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config

# Restart SSH service to apply changes
systemctl restart sshd

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
docker compose -f bitwarden-compose.yml up -d
docker compose -f caddyv2-compose.yml up -d
docker compose -f portainer-compose.yml up -d
#docker compose -f tailscale-compose.yml up -d