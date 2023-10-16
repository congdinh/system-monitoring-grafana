# Dev Monitoring Stack

This repository contains a Docker Compose configuration to set up a monitoring stack using Prometheus, Grafana, Alertmanager, Node Exporter, and Blackbox Exporter.

## Introduction

This is a monitoring stack using Grafana and Prometheus to monitor your applications and systems. This stack includes the following services:

- Grafana: A beautiful and powerful user interface for viewing and visualizing monitoring data.

- Prometheus: A real-time time-series database for storing monitoring data.

- Blackbox Exporter is a tool for probing endpoints over HTTP, HTTPS, DNS, TCP, and ICMP. It allows you to monitor the availability and response times of your services and applications. Here, we'll set up Blackbox Exporter to perform health check monitoring on various endpoints.

- Alertmanager: A tool to handle alerts and notifications.

- Node Exporter is a Prometheus exporter for hardware and OS metrics exposed by Unix kernels. It allows you to monitor various aspects of your servers, including CPU, memory, disk, and network usage. You can set up Node Exporter to collect data from multiple servers and centralize the monitoring.

- PM2-metric Exporter: An exporter to monitor PM2 processes and their metrics.

- Various Exporters for applications like MongoDB, MySQL, Elasticsearch, PM2 and many other types of services.

## Requirements

- Docker and Docker Compose installed on your system.

## Usage

1. Clone the repo from GitHub:

   ```shell
   git clone
   cd system-monitoring-grafana
   ```

2. Create an .env file to provide the necessary environment variables:

   ```sh
   cp .env.example .env
   # Edit the values in the .env file according to your requirements.
   ```

3. Start the services:

   ```sh
   docker-compose up -d
   ```

- Access Grafana at http://localhost:3002 and log in with the username and password you configured in the .env file.

- Prometheus: http://localhost:9090 and log in with the username and password you configured in the prometheus/web.yml file.

- Alertmanager: http://localhost:9093

- Node Exporter metrics: http://localhost:9100/targets

- Blackbox Exporter metrics: http://localhost:9115/targets

- PM2-metric Exporter metrics: http://localhost:9209/metrics

## Configuration and Customization

### Grafana

- Grafana configuration can be customized in the grafana/grafana-config/grafana.ini file.
  Dashboards for specific monitoring services can be found in the grafana/dashboards directory. You can add, remove, or edit these dashboards to suit your needs.
  > Caution: Set permissions for grafana storage `sudo chown -R 472:0 grafana/grafana-storage`

### Prometheus

The Prometheus configuration is defined in the prometheus/prometheus.yml file. Customize scrape configurations for various jobs, such as MongoDB, MySQL, Elasticsearch, Blackbox, PM2 and more, in this file.

Prometheus Alert rules at prometheus/rules/\*.yml

### Alertmanager

The Alertmanager configuration is defined in the alertmanager/config.yml file. You can customize routes, receivers, and notification channels according to your needs.
You can also enhance the Alertmanager configuration to include Slack integration for receiving alerts and notifications.

### Advanced Configurations

- The configurations for Grafana and Prometheus can be customized in the respective configuration files in the grafana and prometheus directories.

- To add or remove specific monitoring services (e.g., Redis, Postgres, Node Exporter), edit the docker-compose.yml file.

- Adjust Prometheus rules in rules/ and Grafana dashboards in grafana/dashboards/ as required. Node Exporter collects server metrics, Blackbox Exporter health checks, and PM2-metric Exporter metrics from targets specified in prometheus/prometheus.yml.

- Alertmanager Configuration:
  The Alertmanager configuration is defined in the alertmanager/config.yml file. You can customize routes, receivers, and notification channels according to your needs.

- Prometheus Configuration:
  The Prometheus configuration is defined in the prometheus/prometheus.yml file. Below is a brief overview of the configuration:

  ```sh
  # My global config
  global:
    scrape_interval: 30s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
    evaluation_interval: 30s # Evaluate rules every 15 seconds. The default is every 1 minute.

    # Attach these labels to any time series or alerts when communicating with
    # external systems (federation, remote storage, Alertmanager).
    external_labels:
      monitor: "monitoring"

  # Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
  rule_files:
    - "rules/*.yml"

  # Use this for alerting service
  alerting:
    alertmanagers:
      - scheme: http
        static_configs:
          - targets:
              - "alertmanager:9093"

  ```

- Node Exporter for Server Monitoring

  Set up Node Exporter to collect data from multiple servers and centralize the monitoring.

  ```sh
  # Install this package per each node servers
  sudo apt install prometheus-node-exporter
  # Now check the node exporter is running at port 9100

  sudo service prometheus-node-exporter status
  # You can stop, start or restart a node exporter
  ```

- Blackbox Exporter for Health Check Monitoring

  Customize the targets in the Blackbox Exporter configuration (blackbox/blackbox.yml) to specify the endpoints you want to monitor. Add URLs, IPs, or hostnames of the services you wish to check. You can configure additional parameters like module and timeout to suit your monitoring needs.

  > Optionally, set up specific relabeling configurations for Blackbox Exporter in the Prometheus configuration (prometheus/prometheus.yml) if necessary.

- You can further customize scrape configurations for various jobs, such as MongoDB, MySQL, Elasticsearch, Blackbox, and more, in the prometheus/prometheus.yml file.

- The conversation in this topic includes advanced configurations for integrating Slack, customizing alert messages, and more. Please refer to the conversation for these advanced configurations.

## Learn More

- [Grafana](https://github.com/percona/grafana-dashboards/tree/pmm-1.x/dashboards)
- [Alertmanager](https://samber.github.io/awesome-prometheus-alerts/alertmanager)
- [Prometheus](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)
- [Blackbox Exporter](https://github.com/prometheus/blackbox_exporter)
- [Node Exporter](https://devopscube.com/monitor-linux-servers-prometheus-node-exporter/)
- [PM2-metric Exporter](https://github.com/saikatharryc/pm2-prometheus-exporter)

## License

This project is distributed under the MIT License.
