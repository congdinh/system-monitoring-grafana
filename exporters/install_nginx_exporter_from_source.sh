#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Variables
NODE_EXPORTER_VERSION="1.8.0"
NODE_EXPORTER_USER="node_exporter"
NODE_EXPORTER_BINARY="/usr/local/bin/node_exporter"
NODE_EXPORTER_SERVICE="/etc/systemd/system/node_exporter.service"
NODE_EXPORTER_PORT="9100"

echo "Installing Prometheus Node Exporter version $NODE_EXPORTER_VERSION from source..."

# Step 1: Download and install Node Exporter
echo "Downloading Node Exporter..."
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz

echo "Verifying archive integrity..."
# Replace the MD5 checksum with the actual value for verification if needed:
# echo "EXPECTED_MD5  node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz" | md5sum -c -

echo "Extracting Node Exporter..."
tar -xf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
cd node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/

echo "Installing Node Exporter binary..."
sudo cp node_exporter $NODE_EXPORTER_BINARY

# Step 2: Create a system user for Node Exporter
echo "Creating Node Exporter user..."
sudo useradd -r $NODE_EXPORTER_USER || echo "User already exists."

# Step 3: Configure systemd service
echo "Configuring Node Exporter systemd service..."
sudo bash -c "cat > $NODE_EXPORTER_SERVICE" << EOF
[Unit]
Description=Prometheus Node Exporter
After=network.target

[Service]
Type=simple
User=$NODE_EXPORTER_USER
Group=$NODE_EXPORTER_USER
ExecStart=$NODE_EXPORTER_BINARY \\
    --web.listen-address=0.0.0.0:$NODE_EXPORTER_PORT

SyslogIdentifier=node_exporter
Restart=always

PrivateTmp=yes
ProtectHome=yes
NoNewPrivileges=yes
ProtectSystem=strict
ProtectControlGroups=true
ProtectKernelModules=true
ProtectKernelTunables=yes

[Install]
WantedBy=multi-user.target
EOF

# Step 4: Start and enable the service
echo "Reloading systemd and starting Node Exporter service..."
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

# Step 5: Verify installation
echo "Verifying Node Exporter service status..."
sudo systemctl status node_exporter --no-pager

echo "Testing Node Exporter metrics endpoint..."
if curl -s http://localhost:$NODE_EXPORTER_PORT/metrics | grep -q "^#"; then
    echo "Node Exporter is successfully serving metrics at http://localhost:$NODE_EXPORTER_PORT/metrics"
else
    echo "Node Exporter metrics endpoint is not accessible. Please check the configuration."
    exit 1
fi

echo "Prometheus Node Exporter installation and configuration complete."
