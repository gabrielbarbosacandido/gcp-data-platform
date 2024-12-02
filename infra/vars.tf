# General
variable project_name {
  type    = string
  default = "suzano-challenge"
}

variable region {
  type    = string
  default = "us-central1"
}

variable application_credentials {
  type    = string
  default = file("application_credentials.json")
}

# VPC
variable routing_mode  {
  type    = string
  default = "REGIONAL"
}

variable network_name {
  type    =  string
  default = "suzano-challenge-vpc"
}

variable subnet_a_name {
  type    = string
  default = "subnet_a"
}

variable subnet_b_name {
  type    = string
  default = "subnet_b"
}

variable subnet_a_ip {
  type    = string
  default = "10.10.10.0/24"
}

variable subnet_b_ip {
  type    = string
  default = "10.10.20.0/24"
}

variable subnet_private_access {
  type    = bool
  default = true
}

variable subnet_flow_logs {
  type    = bool
  default = true
}

variable secondary_ranges {
  type = map(list(object({
    range_name    = string
    ip_cidr_range = string
  })))
  default = {
    subnet_a = [
      {
        range_name    = "gke-services"
        ip_cidr_range = "192.168.1.0/24"
      }
    ]
    subnet_b = [
      {
        range_name    = "gke-pods"
        ip_cidr_range = "192.168.30.0/24"
      }
    ]
  }
}

variable routes {
  description = "Configuração de rotas da VPC"
  type = list(object({
    name              = string
    destination_range = string
    next_hop_internet = bool
  }))
  default = [
    {
      name              = "vpn-route"
      destination_range = "10.50.10.0/24"
      next_hop_internet = true
    }
  ]
}

# VPN
variable gateway_name {
  type    = string
  default = "${var.project_id}-vpn-prod-internal"
}

variable tunnel_name_prefix {
  type    = string
  default = "${var.project_id}-vpn-tn-prod-internal"
}

variable shared_secret {
  type    = string
  default = "secrets"
}

variable tunnel_count {
  type    = number
  default = 1
}

variable peer_ips {
  type    = list(string)
  default = [
    "1.1.1.1", 
    "2.2.2.2"
  ]
}

variable route_priority  {
  type    = number
  default = 1000
}

variable remote_subne {
  type    = list(string)
  default = [
    "10.50.10.0/24"
  ]
}

# GCS
variable bucket_name {
  type    = string
  default = "suzano_raw_data"
}

variable location {
  type    = string
  default = "US"
}

variable storage_class {
  type    = string
  default = "STANDARD"
}

variable force_destroy {
  type    = bool
  default = true
}

variable uniform_bucket_level_access {
  type    = bool
  default = true
}

variable role {
  type    = string
  default = "roles/storage.objectViewer"
}

variable members {
  type    = list(string)
  default = [
    "roles/storage.objectViewer"
  ]
}

#DNS
variable ingress_gateway_ip_airflow {
  type = string
}

variable ingress_gateway_ip_trino {
  type = string
}

variable domain {
  type    = string
  default = "prd.com.br"
}

variable dns_type {
  type    = string
  default = "private"
}

variable private_visibility_config_networks {
  type    = list (string)
  default = [
    "https://www.googleapis.com/compute/v1/projects/${var.project_id}/global/networks/${module.vpc.network_name}"  # Associe à sua VPC
  ]
}

variable dns_recordsets {
  type = list(object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
  }))
  default = [
    {
      name    = "prd.com.br"
      type    = "NS"
      ttl     = 300
      records = [
        "ns-cloud-e1.googledomains.com.",
        "ns-cloud-e2.googledomains.com.",
        "ns-cloud-e3.googledomains.com.",
        "ns-cloud-e4.googledomains.com."
      ]
    },
    {
      name    = "suzano-airflow.prd.com.br"
      type    = "A"
      ttl     = 300
      records = [
        "<IP_INGRESS_GATEWAY_AIRFLOW>"
      ]
    },
    {
      name    = "suzano-trino.prd.com.br"
      type    = "A"
      ttl     = 300
      records = [
        "<IP_INGRESS_GATEWAY_TRINO>"
      ]
    },
    {
      name    = "suzano-ranger.prd.com.br"
      type    = "A"
      ttl     = 300
      records = [
        "<IP_INGRESS_GATEWAY_TRINO>"
      ]
    }
    {
      name    = "suzano-grafana.prd.com.br"
      type    = "A"
      ttl     = 300
      records = [
        "<IP_INGRESS_GATEWAY_TRINO>"
      ]
    }
  ]
}

# GCR
variable gcr_members {
  type    = list(string)
  default = [
    "user:*.suzano.com.br",
  ]
}

variable gcr_role {
  type = string
  default = "roles/storage.objectAdmin"
}

#GKE
variable node_pool_trino {
  type = object({
    name            = string
    machine_type    = string
    node_locations  = string
    min_count       = number
    max_count       = number
    disk_size_gb    = number
    disk_type       = string
    preemptible     = bool
    initial_node_count  = number
    accelerator_count   = number
    accelerator_type    = string
    gpu_driver_version  = string
    gpu_sharing_strategy = string
    max_shared_clients_per_gpu = number
  })
  default = {
    name               = "trino-node-pool"
    machine_type       = "n1-highmem-16"
    node_locations     = "us-central1-b,us-central1-c"
    min_count          = 1
    max_count          = 10
    disk_size_gb       = 100
    disk_type          = "pd-standard"
    preemptible        = false
    initial_node_count = 3
    accelerator_count  = 0
    accelerator_type   = "nvidia-l4"
    gpu_driver_version = "LATEST"
    gpu_sharing_strategy   = "TIME_SHARING"
    max_shared_clients_per_gpu = 2
  }
}

variable node_pool_grafana {
  type = object({
    name            = string
    machine_type    = string
    node_locations  = string
    min_count       = number
    max_count       = number
    disk_size_gb    = number
    disk_type       = string
    preemptible     = bool
    initial_node_count  = number
    accelerator_count   = number
    accelerator_type    = string
    gpu_driver_version  = string
    gpu_sharing_strategy = string
    max_shared_clients_per_gpu = number
  })
  default = {
    name               = "grafana"
    machine_type       = "e2-medium"
    node_locations     = "us-central1-b,us-central1-c"
    min_count          = 1
    max_count          = 10
    disk_size_gb       = 100
    disk_type          = "pd-standard"
    preemptible        = false
    initial_node_count = 3
    accelerator_count  = 0
    accelerator_type   = "nvidia-l4"
    gpu_driver_version = "LATEST"
    gpu_sharing_strategy   = "TIME_SHARING"
    max_shared_clients_per_gpu = 2
  }
}

variable node_pool_airflow {
  type = object({
    name            = string
    machine_type    = string
    node_locations  = string
    min_count       = number
    max_count       = number
    disk_size_gb    = number
    disk_type       = string
    preemptible     = bool
    initial_node_count  = number
    accelerator_count   = number
    accelerator_type    = string
    gpu_driver_version  = string
    gpu_sharing_strategy = string
    max_shared_clients_per_gpu = number
  })
  default = {
    name               = "airflow-node-pool"
    machine_type       = "e2-medium"
    node_locations     = "us-central1-b,us-central1-c"
    min_count          = 1
    max_count          = 10
    disk_size_gb       = 100
    disk_type          = "pd-standard"
    preemptible        = false
    initial_node_count = 3
    accelerator_count  = 0
    accelerator_type   = "nvidia-l4"
    gpu_driver_version = "LATEST"
    gpu_sharing_strategy   = "TIME_SHARING"
    max_shared_clients_per_gpu = 2
  }
}

variable node_pool_ranger {
  type = object({
    name            = string
    machine_type    = string
    node_locations  = string
    min_count       = number
    max_count       = number
    disk_size_gb    = number
    disk_type       = string
    preemptible     = bool
    initial_node_count  = number
    accelerator_count   = number
    accelerator_type    = string
    gpu_driver_version  = string
    gpu_sharing_strategy = string
    max_shared_clients_per_gpu = number
  })
  default = {
    name               = "ranger-node-pool"
    machine_type       = "e2-medium"
    node_locations     = "us-central1-b,us-central1-c"
    min_count          = 1
    max_count          = 10
    disk_size_gb       = 100
    disk_type          = "pd-standard"
    preemptible        = false
    initial_node_count = 3
    accelerator_count  = 0
    accelerator_type   = "nvidia-l4"
    gpu_driver_version = "LATEST"
    gpu_sharing_strategy   = "TIME_SHARING"
    max_shared_clients_per_gpu = 2
  }
}

variable node_pools_oauth_scopes {
  type = map(list(string))
  default = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

variable node_pools_taints {
  description = "Taints para pools de nós"
  type = map(list(object({
    key    = string
    value  = string
    effect = string
  })))
  default = {
    trino-node-pool = [
      {
        key    = "trino-node-pool"
        value  = "true"
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
    airflow-node-pool = [
      {
        key    = "airflow-node-pool"
        value  = "true"
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }
}
