# xpra-with-nginx-setup
xpra installation with nginx for remotly access linux desktop over 443 port

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
- Registered domain or subdomain (e.g., `display.example.com`)

---

## 🚀 Installation

Clone and run the script as root or with sudo:

```bash
git clone https://github.com/yourusername/xpra-headless-server-setup.git
cd xpra-headless-server-setup
chmod +x install.sh
sudo ./install.sh
