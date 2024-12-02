module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.3"

  project_id   = var.project_id
  network_name = var.network_name
  routing_mode = var.route_name
  subnets = [
    {
      subnet_name           = var.subnet_a_name
      subnet_ip             = var.subnet_a_ip
      subnet_region         = var.region
      subnet_private_access = tostring(var.subnet_private_access)
      subnet_flow_logs      = tostring(var.subnet_flow_logs)
    },
    {
      subnet_name           = var.subnet_b_name
      subnet_ip             = var.subnet_b_ip
      subnet_region         = var.region
      subnet_private_access = tostring(var.subnet_private_access)
      subnet_flow_logs      = tostring(var.subnet_flow_logs)
    }
  ]
  secondary_ranges = var.secondary_ranges
  routes = var.routes
}