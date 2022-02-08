locals {
  name = "cg-iks-prod"
}

module "terraform-intersight-iks" {
  source  = "terraform-cisco-modules/iks/intersight//"
  version = "2.2.1"



  # Kubernetes Cluster Profile  Adjust the values as needed.
  cluster = {
    name                = local.name
    action              = "Unassign"
    wait_for_completion = false
    worker_nodes        = 1
    load_balancers      = 1
    worker_max          = 1
    control_nodes       = 1
    ssh_user            = var.ssh_user
    ssh_public_key      = var.ssh_key
  }


  # IP Pool Information (To create new change "use_existing" to 'false' uncomment variables and modify them to meet your needs.)
  ip_pool = {
    use_existing = true
    name         = "cg-iks-pool-1"
    # ip_starting_address = "10.239.21.220"
    # ip_pool_size        = "20"
    # ip_netmask          = "255.255.255.0"
    # ip_gateway          = "10.239.21.1"
    # dns_servers         = ["10.101.128.15","10.101.128.16"]
  }

  # Sysconfig Policy (UI Reference NODE OS Configuration) (To create new change "use_existing" to 'false' uncomment variables and modify them to meet your needs.)
  sysconfig = {
    use_existing = false
    name         = local.name
    domain_name  = "ceclab.info"
    timezone     = "Australia/Sydney"
    ntp_servers  = ["ntp.esl.cisco.com"]
    dns_servers  = ["10.67.28.130"]
  }

  # Kubernetes Network CIDR (To create new change "use_existing" to 'false' uncomment variables and modify them to meet your needs.)
  k8s_network = {
    use_existing = false
    name         = local.name

    ######### Below are the default settings.  Change if needed. #########
    # pod_cidr     = "100.65.0.0/16"
    # service_cidr = "100.64.0.0/24"
    # cni          = "Calico"
  }
  # Version policy (To create new change "useExisting" to 'false' uncomment variables and modify them to meet your needs.)
  versionPolicy = {
    useExisting    = false
    policyName     = local.name
    iksVersionName = "1.20.14-iks.0" #"1.19.15-iks.5"
  }

  # Trusted Registry Policy (To create new change "use_existing" to 'false' and set "create_new' to 'true' uncomment variables and modify them to meet your needs.)
  # Set both variables to 'false' if this policy is not needed.
  tr_policy = {
    use_existing = false
    create_new   = false
    name         = "trusted-registry"
  }
  # Runtime Policy (To create new change "use_existing" to 'false' and set "create_new' to 'true' uncomment variables and modify them to meet your needs.)
  # Set both variables to 'false' if this policy is not needed.
  runtime_policy = {
    use_existing = false
    create_new   = false
    # name                 = "runtime"
    # http_proxy_hostname  = "t"
    # http_proxy_port      = 80
    # http_proxy_protocol  = "http"
    # http_proxy_username  = null
    # http_proxy_password  = null
    # https_proxy_hostname = "t"
    # https_proxy_port     = 8080
    # https_proxy_protocol = "https"
    # https_proxy_username = null
    # https_proxy_password = null
  }

  # Infrastructure Configuration Policy (To create new change "use_existing" to 'false' and uncomment variables and modify them to meet your needs.)
  infraConfigPolicy = {
    use_existing       = false
    policyName         = local.name
    platformType       = "esxi"
    targetName         = "prodvcenter.ceclab.info"
    description        = "Infra config policy for cluster ${local.name}"
    interfaces         = ["vm-network-28"]
    vcTargetName       = "prodvcenter.ceclab.info"
    vcClusterName      = "Melb-HX-Hybrid"
    vcDatastoreName    = "cgascoig-1"
    vcResourcePoolName = ""
    vcPassword         = var.vc_password
  }

  # Addon Profile and Policies (To create new change "createNew" to 'true' and uncomment variables and modify them to meet your needs.)
  # This is an Optional item.  Comment or remove to not use.  Multiple addons can be configured.
  addons = [
    # {
    # createNew = true
    # addonPolicyName = "${local.name}-smm-tf"
    # addonName            = "smm"
    # description       = "SMM Policy"
    # upgradeStrategy  = "AlwaysReinstall"
    # installStrategy  = "InstallOnly"
    # releaseVersion = "1.8.1-cisco2-helm3"
    # overrides = yamlencode({"demoApplication":{"enabled":true}})
    # },
    # {
    # createNew = true
    # addonName            = "ccp-monitor"
    # description       = "monitor Policy"
    # # upgradeStrategy  = "AlwaysReinstall"
    # # installStrategy  = "InstallOnly"
    # releaseVersion = "0.2.61-helm3"
    # # overrides = yamlencode({"demoApplication":{"enabled":true}})
    # },
  ]

  # Worker Node Instance Type (To create new change "use_existing" to 'false' and uncomment variables and modify them to meet your needs.)
  instance_type = {
    use_existing = false
    name         = local.name
    cpu          = 4
    memory       = 16386
    disk_size    = 40
  }

  # Organization and Tag Information
  organization = "default"
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