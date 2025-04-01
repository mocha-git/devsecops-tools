Project for school by Osama Emam and Victor Lemoine

# Observability Zero Trust Project

This repository provides a comprehensive observability solution coupled with a Zero Trust approach to enhance the security of your systems. It leverages:

- **OpenTelemetry** for instrumentation (logs, metrics, traces),
- **Prometheus** for scraping and short-term storage of metrics,
- **Loki** (or ELK) for log storage,
- **Grafana** for visualization and alerting,
- **Wazuh** (or Splunk) as a SIEM for advanced correlation and anomaly detection,
- **Infrastructure as Code** (Terraform, Helm) for deploying and managing environments.

## 1. Overview

The architecture aims to deliver an end-to-end observability platform (metrics, logs, traces) along with a security component leveraging a SIEM. It follows Zero Trust principles:
- **Network segmentation** and isolation of components (Prometheus, Loki, SIEM, etc.),
- **TLS encryption** for data collection and transport,
- **Filtering and masking** of sensitive information (PII, secrets, tokens) within logs.

With this stack, you can:
- **Detect** performance and availability issues,
- **Monitor** the health of microservices and infrastructure,
- **Correlate** security events to quickly identify attacks or abnormal behavior,
- **Alert** relevant teams (Slack, email, SIEM) with thresholds and detection rules tailored to your needs.

## 2. Architecture

+-------------------------------+ | Applications & Services | +-------------------------------+ | OpenTelemetry Agents/SDK v +-------------------------------+ | Collection & Ingestion | | (Prometheus, OTel Collector, | | FluentBit, Logstash...) | +-------------------------------+ | | | +-------------------------------+ | Processing Pipelines | | (Filtering, Masking, etc.) | +-------------------------------+ | | | +-------------------------------+ +-----------------------------+ | Prometheus TSDB (metrics) | | Logs (Loki / Elasticsearch) | +-------------------------------+ +-----------------------------+ | | | +-----------------------------------------------------+ | SIEM (Wazuh / Splunk) | | (Correlation, Advanced Detection) | +-----------------------------------------------------+ | +-----------------------------------------------------+ | Grafana & Alerting | +-----------------------------------------------------+


## 3. Prerequisites

- **Terraform** (v1.0+)
- **Helm** (v3+) and **kubectl** if you are deploying on Kubernetes
- **Docker** / **docker-compose** (optional) for running some services locally
- **Cloud access** (AWS, GCP, Azure) or an **existing Kubernetes cluster** (on-prem or cloud)
- **Wazuh** or **Splunk** depending on your SIEM preference

## 4. Repository Structure

- **terraform/**  
  Contains Terraform scripts for creating a Kubernetes cluster (e.g., EKS on AWS), subnets, etc.

- **helm-charts/**  
  Holds (or references) custom `values.yaml` files for installing Prometheus, Grafana, Loki, etc.

- **k8s-manifests/**  
  Example Kubernetes deployments (OTel Collector, instrumented applications).

- **app-examples/**  
  Example code bases (e.g., Go) instrumented with OpenTelemetry.

- **docker-compose/**  
  Sample Wazuh or Splunk configurations (local testing, optional).

## 5. Quickstart

### 5.1. Create Infrastructure (AWS EKS Example)

```bash
cd terraform/
terraform init
terraform plan -var="aws_region=us-east-1"
terraform apply -var="aws_region=us-east-1" -auto-approve

### 5.2. Deploy Components on Kubernetes (Helm)

**Prometheus**
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install my-prometheus prometheus-community/prometheus --namespace observability --create-namespace -f helm-charts/prometheus-values.yaml

**Grafana**

helm repo add grafana https://grafana.github.io/helm-charts
helm install my-grafana grafana/grafana --namespace observability -f helm-charts/grafana-values.yaml

**Loki**

helm repo add loki https://grafana.github.io/loki/charts
helm install my-loki loki/loki --namespace observability -f helm-charts/loki-values.yaml

**OpenTelemetry**

kubectl apply -f k8s-manifests/otel-collector.yaml
