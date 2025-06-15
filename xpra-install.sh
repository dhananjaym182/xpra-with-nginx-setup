#!/bin/bash

set -e

# Prompt user for input
read -rp "Enter your domain name (e.g., display.magnetbyte.com): " DOMAIN
read -rp "Enter bind address [127.0.0.1 or 0.0.0.0]: " BIND_ADDR
read -rp "Enter non-root username to run Xpra: " USERNAME
read -rsp "Enter password for Xpra access: " XPRA_PASS
echo ""

# Define paths
SSL_DIR="/etc/ssl/xpra"
XPRA_PASS_FILE="/home/$USERNAME/.xpra/xpra.pass"
XPRA_SERVICE="/etc/systemd/system/xpra-remote.service"

# Update and install prerequisites
sudo apt update
sudo apt install -y gnupg curl lsb-release ca-certificates nginx openssl

# Add official Xpra repository
curl -fsSL https://xpra.org/gpg.asc | sudo tee /usr/share/keyrings/xpra.asc > /dev/null
echo "deb https://xpra.org/repos/$(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/xpra.list
sudo apt update
sudo apt install -y xpra xpra-html5

# Create SSL cert
sudo mkdir -p "$SSL_DIR"
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout "$SSL_DIR/xpra.key" -out "$SSL_DIR/xpra.crt" \
  -subj "/C=US/ST=None/L=None/O=Magnetbyte/OU=Xpra/CN=$DOMAIN"

# Create Xpra password file
sudo mkdir -p "/home/$USERNAME/.xpra"
echo -n "$XPRA_PASS" | sudo tee "$XPRA_PASS_FILE" > /dev/null
sudo chown -R "$USERNAME":"$USERNAME" "/home/$USERNAME/.xpra"
sudo chmod 600 "$XPRA_PASS_FILE"

# Create systemd service file
cat <<EOF | sudo tee "$XPRA_SERVICE"
[Unit]
Description=Xpra Headless Session
After=network.target

[Service]
User=$USERNAME
Environment=DISPLAY=:100
ExecStart=/usr/bin/xpra start :100 \
  --bind-tcp=$BIND_ADDR:14500,auth=file,filename=$XPRA_PASS_FILE \
  --html=on \
  --ssl=on \
  --ssl-cert=$SSL_DIR/xpra.crt \
  --ssl-key=$SSL_DIR/xpra.key
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable the service
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable xpra-remote
sudo systemctl start xpra-remote

# Configure Nginx as reverse proxy for port 443
cat <<EOF | sudo tee /etc/nginx/sites-available/xpra
server {
    listen 443 ssl;
    server_name $DOMAIN;

    ssl_certificate     $SSL_DIR/xpra.crt;
    ssl_certificate_key $SSL_DIR/xpra.key;

    location / {
        proxy_pass https://127.0.0.1:14500/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/xpra /etc/nginx/sites-enabled/xpra
sudo nginx -t && sudo systemctl restart nginx

echo -e "\n✅ Xpra HTML5 server is installed and accessible at: https://$DOMAIN/"
echo "Use the username: $USERNAME and your chosen password to log in."
