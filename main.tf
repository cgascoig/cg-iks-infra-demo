

module "terraform-intersight-iks" {
  source = "terraform-cisco-modules/iks/intersight//"
  version = "0.9.21"

  # Infra Config Policy Information
  cluster_name = "cg-iks-prod"
  cluster_action = "Deploy"
  vc_target_name   = "10.67.17.125"
  vc_portgroup     = ["vm-network-28"]
  vc_datastore     = "cgascoig-1"
  vc_cluster       = "Melb-HX-Hybrid"
  vc_resource_pool = ""
  vc_password      = var.vc_password

  # IP Pool Information
  ip_starting_address = "10.67.28.235"
  ip_pool_size        = "5"
  ip_netmask          = "255.255.255.128"
  ip_gateway          = "10.67.28.129"
  ip_primary_dns      = "10.67.28.130"
  ip_secondary_dns    = "10.67.28.130"
  ip_primary_ntp      = "ntp.esl.cisco.com"
  ip_secondary_ntp      = "ntp.esl.cisco.com"

  # Network Configuration Settings
  # pod_cidr = "100.65.0.0/16"
  # service_cidr = "100.64.0.0/24"
  # cni = "Calico"
  domain_name         = "aci.ceclab.info"
  timezone            = "Australia/Sydney"
#   unsigned_registries = ["10.101.128.128"]
  # root_ca_registries  = [""]

  # Cluster information
  ssh_user     = var.ssh_user
  ssh_key      = var.ssh_key
  worker_size  = "small"
  worker_count = 1
  master_count = 1
  load_balancers = 1
  # Organization and Tag
#   organization = var.organization
#   tags         = var.tags
}

# bump 1