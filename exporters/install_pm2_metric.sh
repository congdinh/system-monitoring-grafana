#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Installing PM2 and PM2-Metric..."

# Step 1: Update the system
echo "Updating package lists..."
sudo apt update

# Step 2: Install Node.js and npm if not already installed
echo "Checking for Node.js and npm..."
if ! command -v node &>/dev/null; then
  echo "Node.js not found."
  exit 1
else
  echo "Node.js is already installed."
fi

# Step 3: Install PM2 globally
echo "Installing PM2 globally using npm..."
sudo npm install -g pm2

# Step 4: Install the PM2-Metric module
echo "Installing PM2-Metric module..."
pm2 install pm2-metric

# Step 5: Verify PM2-Metric installation
echo "Verifying PM2-Metric..."
if pm2 list | grep -q "pm2-metric"; then
  echo "PM2-Metric installed successfully."
else
  echo "PM2-Metric installation failed. Please check the logs."
  exit 1
fi

echo "PM2 and PM2-Metric setup complete."
