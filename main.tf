

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

  domain_name         = "aci.ceclab.info"
  timezone            = "Australia/Sydney"

  # Cluster information
  ssh_user     = var.ssh_user
  ssh_key      = var.ssh_key
  worker_size  = "small"
  worker_count = 1
  master_count = 1
  load_balancers = 1
}

data "intersight_kubernetes_cluster" "iks" {
    name = "cg-iks-prod"

    depends_on = [
      module.terraform-intersight-iks
    ]
}

output "kube_config" {
  value = data.intersight_kubernetes_cluster.iks.results[0].kube_config
}