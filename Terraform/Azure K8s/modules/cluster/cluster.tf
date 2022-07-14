
resource "azurerm_resource_group" "tf_aks_group" {
  name     = "Terraform-AKS-Resource-Group"
  location = "Central US"
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "Terraform-AKS-Cluster"
  location            = azurerm_resource_group.tf_aks_group.location
  resource_group_name = azurerm_resource_group.tf_aks_group.name
  dns_prefix          = "TerraformAKS"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "standard_d4ads_v5"
    type      = "VirtualMachineScaleSets" #this is also the default#
    os_disk_size_gb = 250
  }

  service_principal {
    client_id     = var.serviceprincipal
    client_secret = var.serviceprincipal_key
  }


  linux_profile {
    admin_username = "azureuser"
    ssh_key {
        key_data = var.ssh_key
    }
  }


  network_profile {
    network_plugin = "kubenet" #there are curently only two values supported, kubenet/ azure
    load_balancer_sku = "standard"
  }

}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
}