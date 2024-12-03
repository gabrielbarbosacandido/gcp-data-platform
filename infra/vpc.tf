module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.3"

  project_id   = var.project_id
  network_name = var.network_name
  routing_mode = var.route_name
  subnets = [
    {
      subnet_name           = var.private_subnet_a
      subnet_ip             = var.private_subnet_a_ip
      subnet_region         = var.region
      subnet_private_access = tostring(var.subnet_private_access)
      subnet_flow_logs      = tostring(var.subnet_flow_logs)
    },
    {
      subnet_name           = var.private_subnet_b
      subnet_ip             = var.private_subnet_b_ip
      subnet_region         = var.region
      subnet_private_access = tostring(var.subnet_private_access)
      subnet_flow_logs      = tostring(var.subnet_flow_logs)
    },
    {
      subnet_name           = var.public_subnet_a
      subnet_ip             = var.public_subnet_a_ip
      subnet_region         = var.region
      subnet_flow_logs      = tostring(var.subnet_flow_logs)
    },
    {
      subnet_name           = var.publico_subnet_b
      subnet_ip             = var.public_subnet_b_ip
      subnet_region         = var.region
      subnet_flow_logs      = tostring(var.subnet_flow_logs)
    }
  ]
  secondary_ranges = var.secondary_ranges
  routes = var.routes
  
  ingress_rules = [
    {
      name                    = "allow-http"
      description             = "Allow HTTP traffic"
      disabled                = false
      priority                = 1000
      destination_ranges      = ["0.0.0.0/0"]
      source_ranges           = ["0.0.0.0/0"]
      allow = [
        {
          protocol = "tcp"
          ports    = ["80"]
        }
      ]
    },
    {
      name                    = "allow-https"
      description             = "Allow HTTPS traffic"
      disabled                = false
      priority                = 1001
      destination_ranges      = ["0.0.0.0/0"]
      source_ranges           = ["0.0.0.0/0"]
      allow = [
        {
          protocol = "tcp"
          ports    = ["443"]
        }
      ]
    }
  ]

  egress_rules = [
    {
      name                    = "allow-all-egress"
      description             = "Allow all egress traffic"
      disabled                = false
      priority                = 1000
      destination_ranges      = ["0.0.0.0/0"]
      source_ranges           = ["0.0.0.0/0"]
      allow = [
        {
          protocol = "tcp"
          ports    = ["0-65535"]
        }
      ]
    }
  ]
}
