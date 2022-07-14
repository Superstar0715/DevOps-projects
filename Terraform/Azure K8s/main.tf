provider "azurerm" {
    #version = "3.0.1" version constraints are now depreciated
    
    subscription_id = var.subscription_id
    client_id       = var.serviceprincipal
    client_secret   = var.serviceprincipal_key
    tenant_id       = var.tenant_id

    features {}
}

module cluster {
  source               = "./modules/cluster/"
  serviceprincipal     = var.serviceprincipal
  serviceprincipal_key = var.serviceprincipal_key
  ssh_key              = var.ssh_key
}
