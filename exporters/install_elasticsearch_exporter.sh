#!/bin/bash

# Download Elasticsearch Exporter
sudo wget https://github.com/prometheus-community/elasticsearch_exporter/releases/download/v1.5.0/elasticsearch_exporter-1.5.0.linux-amd64.tar.gz

# Extract the tar.gz file
sudo tar -xvzf elasticsearch_exporter-1.5.0.linux-amd64.tar.gz

# Create a system user for Elasticsearch
sudo useradd --no-create-home --shell /bin/false elasticsearch_exporter

# Move to the extracted directory
cd elasticsearch_exporter-1.5.0.linux-amd64/

# Copy the exporter binary to /usr/local/bin/
sudo cp elasticsearch_exporter /usr/local/bin/

# Change ownership of the exporter binary
sudo chown elasticsearch:elasticsearch /usr/local/bin/elasticsearch_exporter

# Create a systemd service file
sudo tee /etc/systemd/system/elasticsearch_exporter.service > /dev/null << EOL
[Unit]
Description=Prometheus Elasticsearch Exporter
After=local-fs.target network-online.target network.target
Wants=local-fs.target network-online.target network.target

[Service]
User=elasticsearch
Nice=10
ExecStart=/usr/local/bin/elasticsearch_exporter --es.uri http://user:pass@127.0.0.1:9200 --es.all --es.indices --es.cluster_settings --es.timeout 30s
ExecStop=/usr/bin/killall elasticsearch_exporter
Restart=always

[Install]
WantedBy=default.target
EOL

# Start the Elasticsearch Exporter service
sudo systemctl start elasticsearch_exporter.service

# Enable the service to start on boot
sudo systemctl enable elasticsearch_exporter.service

# Check the status of the Elasticsearch Exporter service
sudo systemctl status elasticsearch_exporter.service