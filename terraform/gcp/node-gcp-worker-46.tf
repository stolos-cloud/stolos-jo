# GCP Talos Node: gcp-worker-46
# Managed by Stolos - Generated at 2025-11-04T12:53:59Z
# Talos config stored in GCS bucket

# Fetch Talos machine configuration from GCS storage
data "google_storage_bucket_object_content" "gcp-worker-46_config" {
  name   = "talos-configs/gcp-worker-46.yaml"
  bucket = "jo-cluster-tf-state-vwo3y8ze"
}

module "gcp-worker-46" {
  source = "../../modules/node"

  name         = "gcp-worker-46"
  machine_type = "n1-standard-2"
  zone         = "us-central1-a"
  region       = "us-central1"
  role         = "worker"
  architecture = "amd64"

  talos_config = data.google_storage_bucket_object_content.gcp-worker-46_config.content

  # Network configuration
  network_name    = "jo-cluster-vpc"
  subnetwork_name = "jo-cluster-subnet"

  disk_size_gb = 100
  disk_type    = "pd-standard"
}

output "gcp-worker-46_info" {
  value = {
    instance_id   = module.gcp-worker-46.instance_id
    instance_name = module.gcp-worker-46.instance_name
    internal_ip   = module.gcp-worker-46.internal_ip
    external_ip   = module.gcp-worker-46.external_ip
    zone          = module.gcp-worker-46.zone
    status        = module.gcp-worker-46.status
  }
  description = "Node information for gcp-worker-46"
}