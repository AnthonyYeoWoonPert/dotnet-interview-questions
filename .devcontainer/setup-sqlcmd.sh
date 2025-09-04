#!/usr/bin/env bash
set -euo pipefail

# Install prerequisites
sudo apt-get update
sudo apt-get install -y curl gnupg apt-transport-https ca-certificates

# Add Microsoft package repo (Debian 12 / bookworm)
curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-prod.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" | sudo tee /etc/apt/sources.list.d/microsoft-prod.list > /dev/null

sudo apt-get update
sudo apt-get install -y mssql-tools18 unixodbc-dev

# Make sqlcmd available in PATH for bash sessions
echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.zshrc || true