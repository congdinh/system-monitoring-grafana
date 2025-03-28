#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Installing Prometheus NGINX Exporter..."

# Step 1: Install prometheus-nginx-exporter
sudo apt update
sudo apt -y install prometheus-nginx-exporter

echo "Prometheus NGINX Exporter installed successfully."

# Step 2: Update systemd service for Prometheus NGINX Exporter
echo "Configuring Prometheus NGINX Exporter service..."

sudo sed -i 's|^ExecStart=.*|ExecStart=/usr/bin/prometheus-nginx-exporter -nginx.scrape-uri=http://127.0.0.1:8080/status $ARGS|' /lib/systemd/system/prometheus-nginx-exporter.service

# Reload systemd to apply changes
sudo systemctl daemon-reload
echo "Prometheus NGINX Exporter service configured."

# Step 3: Create NGINX status configuration
echo "Configuring NGINX stub_status module..."

NGINX_STATUS_CONF="/etc/nginx/conf.d/nginx_status.conf"

sudo bash -c "cat > $NGINX_STATUS_CONF" <<'EOF'
server {
    listen 8080;
    server_name _;

    location /status {
        stub_status;
        access_log off;
        # Optionally: allow access only from localhost
        allow 127.0.0.1;
        deny all;
    }
}
EOF

# Test NGINX configuration
echo "Testing NGINX configuration..."
sudo nginx -t

# Reload NGINX to apply the new configuration
echo "Reloading NGINX..."
sudo systemctl reload nginx
echo "NGINX stub_status configured."

# Step 4: Start and enable Prometheus NGINX Exporter
echo "Starting and enabling Prometheus NGINX Exporter service..."
sudo systemctl enable prometheus-nginx-exporter
sudo systemctl start prometheus-nginx-exporter

# Step 5: Verify the setup
echo "Verifying Prometheus NGINX Exporter service..."
sudo systemctl status prometheus-nginx-exporter --no-pager

echo "Prometheus NGINX Exporter installation and configuration complete."
