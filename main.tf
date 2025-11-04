provider "azurerm" { 
  tenant_id = var.tenant_id
  subscription_id = var.subscription_id
  resource_provider_registrations = "none"
  feature{} 
}
