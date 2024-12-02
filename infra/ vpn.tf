module "vpn-prod-internal" {
  source  = "terraform-google-modules/vpn/google"
  version = "~> 1.2.0"

  project_id         = var.project_id
  network            = var.network_name
  gateway_name       = var.gateway_name
  tunnel_name_prefix = var.tunnel_name_prefix
  shared_secret      = var.shared_secret
  tunnel_count       = var.tunnel_count
  peer_ips           = var.peer_ips

  route_priority     = var.route_priority
  remote_subnet      = var.route_subnet
}
