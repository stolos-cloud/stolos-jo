# GCP Talos Node: gcp-worker-2
# Managed by Stolos - Generated at 2025-11-01T01:46:49Z
# Talos config stored in GCS bucket

# Fetch Talos machine configuration from GCS storage
data "google_storage_bucket_object_content" "gcp-worker-2_config" {
  name   = "talos-configs/gcp-worker-2.yaml"
  bucket = "jo-cluster-tf-state-vwo3y8ze"
}

module "gcp-worker-2" {
  source = "../../modules/node"

  name         = "gcp-worker-2"
  machine_type = "n1-standard-2"
  zone         = "us-central1-a"
  region       = "us-central1"
  role         = "worker"
  architecture = "amd64"

  talos_config = data.google_storage_bucket_object_content.gcp-worker-2_config.content

  # Network configuration
  network_name    = "jo-cluster-vpc"
  subnetwork_name = "jo-cluster-subnet"

  disk_size_gb = 100
  disk_type    = "pd-standard"
}

output "gcp-worker-2_info" {
  value = {
    instance_id   = module.gcp-worker-2.instance_id
    instance_name = module.gcp-worker-2.instance_name
    internal_ip   = module.gcp-worker-2.internal_ip
    external_ip   = module.gcp-worker-2.external_ip
    zone          = module.gcp-worker-2.zone
    status        = module.gcp-worker-2.status
  }
  description = "Node information for gcp-worker-2"
}