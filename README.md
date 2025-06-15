# xpra-with-nginx-setup
About This Project
This project provides a streamlined way to install and configure Xpra with Nginx as a reverse proxy, allowing secure remote access to a Linux desktop environment over port 443 — the standard HTTPS port.

By combining Xpra's headless remote desktop capabilities with Nginx and a self-signed or Let's Encrypt SSL certificate, this setup enables access to a Linux GUI from any modern browser or Xpra client, bypassing restrictive firewalls or networks that block non-standard ports.

Key Features:

💻 Access your Linux desktop remotely via browser or client.

🔐 HTTPS-secured connection through Cloudflare and Nginx over port 443.

🛡️ Option to enable Full (Strict) SSL mode with self-signed certificates.

⚙️ Dynamic script: prompts for domain, user, bind address, and SSL settings.

📦 Automated setup using systemd, apt, and secure configuration defaults.

Ideal for:

Cloud-based or remote headless Linux servers

Developers and sysadmins who want GUI access without VNC/RDP

Environments where only port 443 is open (e.g., corporate networks or Cloudflare tunnel users)

# Xpra Headless Server Setup

This repository automates the installation and configuration of an Xpra headless remote desktop server using:

- ✅ Xpra (Ubuntu)
- ✅ Optional self-signed SSL certs
- ✅ Custom TCP binding (default `127.0.0.1:14500`)
- ✅ Optional public access via NGINX and Cloudflare
- ✅ Systemd service for persistent sessions

---

## 📦 Requirements

- Ubuntu 22.04 (Jammy) or similar
- Root access
- Registered domain or subdomain (e.g., `https://display.magnetbyte.com`)

---

## 🚀 Installation

Clone and run the script as root or with sudo:

```bash
git clone https://github.com/yourusername/xpra-headless-server-setup.git
cd xpra-headless-server-setup
chmod +x xpra-install.sh
sudo ./xpra-install.sh
