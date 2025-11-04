# GCP Talos Node: gcp-worker-51
# Managed by Stolos - Generated at 2025-11-04T14:05:06Z
# Talos config stored in GCS bucket

# Fetch Talos machine configuration from GCS storage
data "google_storage_bucket_object_content" "gcp-worker-51_config" {
  name   = "talos-configs/gcp-worker-51.yaml"
  bucket = "jo-cluster-tf-state-vwo3y8ze"
}

module "gcp-worker-51" {
  source = "../../modules/node"

  name         = "gcp-worker-51"
  machine_type = "n1-standard-2"
  zone         = "us-central1-a"
  region       = "us-central1"
  role         = "worker"
  architecture = "amd64"

  talos_config = data.google_storage_bucket_object_content.gcp-worker-51_config.content

  # Network configuration
  network_name    = "jo-cluster-vpc"
  subnetwork_name = "jo-cluster-subnet"

  disk_size_gb = 100
  disk_type    = "pd-standard"
}

output "gcp-worker-51_info" {
  value = {
    instance_id   = module.gcp-worker-51.instance_id
    instance_name = module.gcp-worker-51.instance_name
    internal_ip   = module.gcp-worker-51.internal_ip
    external_ip   = module.gcp-worker-51.external_ip
    zone          = module.gcp-worker-51.zone
    status        = module.gcp-worker-51.status
  }
  description = "Node information for gcp-worker-51"
}