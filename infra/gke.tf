module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = var.project_id
  name                       = "${var.project_id}-gke"
  region                     = var.region
  zones                      = ["us-central1-a", "us-central1-b", "us-central1-f"]
  network                    = module.vpc.network_name
  subnetwork                 = module.vpc.subnets[0].subnet_name 
  ip_range_pods              = module.vpc.secondary_ranges["subnet_a"][0].range_name
  ip_range_services          = module.vpc.secondary_ranges["subnet_b"][0].range_name
  http_load_balancing        = false
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false
  dns_cache                  = false

  node_pools = [
    {
      name                        = var.node_pool_trino.name
      machine_type                = var.node_pool_trino.machine_type
      node_locations              = var.node_pool_trino.node_locations
      min_count                   = var.node_pool_trino.min_count
      max_count                   = var.node_pool_trino.max_count
      disk_size_gb                = var.node_pool_trino.disk_size_gb
      disk_type                   = var.node_pool_trino.disk_type
      image_type                  = "COS_CONTAINERD"
      enable_gcfs                 = false
      enable_gvnic                = false
      logging_variant             = "DEFAULT"
      auto_repair                 = true
      auto_upgrade                = true
      service_account             = "project-service-account@${var.project_id}.iam.gserviceaccount.com"
      preemptible                 = var.node_pool_trino.preemptible
      initial_node_count          = var.node_pool_trino.initial_node_count
      accelerator_count           = var.node_pool_trino.accelerator_count
      accelerator_type            = var.node_pool_trino.accelerator_type
      gpu_driver_version          = var.node_pool_trino.gpu_driver_version
      gpu_sharing_strategy        = var.node_pool_trino.gpu_sharing_strategy
      max_shared_clients_per_gpu = var.node_pool_trino.max_shared_clients_per_gpu
    },
    {
      name                        = var.node_pool_airflow.name
      machine_type                = var.node_pool_airflow.machine_type
      node_locations              = var.node_pool_airflow.node_locations
      min_count                   = var.node_pool_airflow.min_count
      max_count                   = var.node_pool_airflow.max_count
      disk_size_gb                = var.node_pool_airflow.disk_size_gb
      disk_type                   = var.node_pool_airflow.disk_type
      image_type                  = "COS_CONTAINERD"
      enable_gcfs                 = false
      enable_gvnic                = false
      logging_variant             = "DEFAULT"
      auto_repair                 = true
      auto_upgrade                = true
      service_account             = "project-service-account@${var.project_id}.iam.gserviceaccount.com"
      preemptible                 = var.node_pool_airflow.preemptible
      initial_node_count          = var.node_pool_airflow.initial_node_count
      accelerator_count           = var.node_pool_airflow.accelerator_count
      accelerator_type            = var.node_pool_airflow.accelerator_type
      gpu_driver_version          = var.node_pool_airflow.gpu_driver_version
      gpu_sharing_strategy        = var.node_pool_airflow.gpu_sharing_strategy
      max_shared_clients_per_gpu = var.node_pool_airflow.max_shared_clients_per_gpu
    }
  ]

  node_pools_oauth_scopes = var.node_pools_oauth_scopes

  node_pools_taints = var.node_pools_taints
}