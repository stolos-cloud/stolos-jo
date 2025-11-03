# GCP Talos Node: gcp-worker-35
# Managed by Stolos - Generated at 2025-11-03T20:06:43Z
# Talos config stored in GCS bucket

# Fetch Talos machine configuration from GCS storage
data "google_storage_bucket_object_content" "gcp-worker-35_config" {
  name   = "talos-configs/gcp-worker-35.yaml"
  bucket = "jo-cluster-tf-state-vwo3y8ze"
}

module "gcp-worker-35" {
  source = "../../modules/node"

  name         = "gcp-worker-35"
  machine_type = "n1-standard-2"
  zone         = "us-central1-a"
  region       = "us-central1"
  role         = "worker"
  architecture = "amd64"

  talos_config = data.google_storage_bucket_object_content.gcp-worker-35_config.content

  # Network configuration
  network_name    = "jo-cluster-vpc"
  subnetwork_name = "jo-cluster-subnet"

  disk_size_gb = 100
  disk_type    = "pd-standard"
}

output "gcp-worker-35_info" {
  value = {
    instance_id   = module.gcp-worker-35.instance_id
    instance_name = module.gcp-worker-35.instance_name
    internal_ip   = module.gcp-worker-35.internal_ip
    external_ip   = module.gcp-worker-35.external_ip
    zone          = module.gcp-worker-35.zone
    status        = module.gcp-worker-35.status
  }
  description = "Node information for gcp-worker-35"
}