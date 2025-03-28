#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Installing Prometheus Node Exporter..."

# Step 1: Update the system and install the node exporter package
sudo apt update
sudo apt -y install prometheus-node-exporter

echo "Prometheus Node Exporter installed successfully."

# Step 2: Enable and start the service
echo "Enabling and starting Prometheus Node Exporter service..."
sudo systemctl enable prometheus-node-exporter
sudo systemctl start prometheus-node-exporter

# Step 3: Verify that the service is running
echo "Verifying Prometheus Node Exporter service status..."
sudo systemctl status prometheus-node-exporter --no-pager

# Step 4: Test if Node Exporter is serving metrics
NODE_EXPORTER_PORT=9100
echo "Checking if Node Exporter is accessible on port $NODE_EXPORTER_PORT..."

if curl -s http://localhost:$NODE_EXPORTER_PORT/metrics | grep -q "^#"; then
    echo "Node Exporter is successfully serving metrics at http://localhost:$NODE_EXPORTER_PORT/metrics"
else
    echo "Node Exporter is not serving metrics. Please check the configuration."
    exit 1
fi

echo "Prometheus Node Exporter installation and configuration complete."
