terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
  backend "gcs" {
    bucket = "jo-cluster-tf-state-vwo3y8ze"
    prefix = "infrastructure/state"
  }
}

provider "google" {
  project = "cedille-464122"
  region  = "us-central1"
}

# VPC Network
resource "google_compute_network" "main_vpc" {
  name                    = "jo-cluster-vpc"
  auto_create_subnetworks = false
}

# Subnet for VM instances
# - On-prem pods: 10.244.0.0/16
# - On-prem services: 10.96.0.0/12
resource "google_compute_subnetwork" "main_subnet" {
  name          = "jo-cluster-subnet"
  ip_cidr_range = "172.16.0.0/20"
  region        = "us-central1"
  network       = google_compute_network.main_vpc.id
}

# Firewall Rules

# Allow KubeSpan WireGuard (UDP 51820)
resource "google_compute_firewall" "kubespan" {
  name    = "jo-cluster-allow-kubespan"
  network = google_compute_network.main_vpc.name

  allow {
    protocol = "udp"
    ports    = ["51820"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["talos-node"]

  description = "Allow KubeSpan WireGuard mesh traffic"
}

# Allow Talos API (TCP 50000)
resource "google_compute_firewall" "talos_api" {
  name    = "jo-cluster-allow-talos-api"
  network = google_compute_network.main_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["50000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["talos-node"]

  description = "Allow Talos API access"
}

# Allow Kubernetes API (TCP 6443)
resource "google_compute_firewall" "kubernetes_api" {
  name    = "jo-cluster-allow-k8s-api"
  network = google_compute_network.main_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["6443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["control-plane"]

  description = "Allow Kubernetes API access to control plane nodes"
}

# Allow internal
resource "google_compute_firewall" "internal_cluster" {
  name    = "jo-cluster-allow-internal"
  network = google_compute_network.main_vpc.name

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }

  source_tags = ["talos-node"]
  target_tags = ["talos-node"]

  description = "Allow all internal traffic between cluster nodes"
}

# Output values for VM provisioning
output "network_name" {
  value = google_compute_network.main_vpc.name
}

output "subnet_name" {
  value = google_compute_subnetwork.main_subnet.name
}