provider "azurerm" {
    version = "3.0.1"
    
    subscription_id = var.subscription_id
    client_id       = var.serviceprincipal
    client_secret   = var.serviceprincipal_key
    tenant_id       = var.tenant_id

}

