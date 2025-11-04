provider "azurerm" { 
  tenant_id = var.tenant_id
  subscription_id = var.subscription_id
  resource_provider_registrations = "none"
  feature{} 
}

resource "azurerm_storage_account" "sg1" { 
  name = "csestoragelogo"
  resource_group_name = var.rg_name
  location = var.location
  account_tier = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = true
} 

resource "azurerm_storage_container" "newcontainer1" { 
  name = "container-logo"
  storage_account_id = azurerm_storage_account.sg1.id
  container_access_type = "blob"
} 

resource "azurerm_storage_account" "sg2" { 
  name = "csestoragelogs" 
  resource_group_name = var.rg_name
  location = var.location
  account_tier = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = true

resource "azurerm_mysql_flexible_server" "serverformation1" { 
  name = "serverformationiac"
location = var.location
resource_group_name = var.rg_name
administrator_login = "Saharlab"
administrator_password = "Azerty0000@"
  sku_name = "B_Standard_B1ms"
  version = "8.0.21"
  geo_redundant_backup_enabled = false
  storage { 
    auto_grow_enabled = false
    size_gb = 20
    io_scaling_enabled = false
    iops = 360
} 
} 
resource "azurerm_mysql_flexible_server_configuration" "ssl_config" {
  name = "require_secure_transport"
  resource_group_name = var.rg_name
  server_name = azurerm_mysql_flexible_server.serverformation1.name
  value = "OFF"
}

resource "azurerm_mysql_flexible_database" "mysqldb1" { 
  name = "mysqldb1-iac"
  resource_group_name = var.rg_name
  server_name = azurerm_mysql_flexible_server.serverformation1.name
  charset = "utf8"
  collation = "utf8_unicode_ci"
    depends_on = [ azurerm_mysql_flexible_server.serverformation1 ] 
} 

#Configure firewall to open access 
resource "azurerm_mysql_flexible_server_firewall_rule" "mysqlfwrule1" { 
  name = "mysqlfwrule1-iac"
  resource_group_name = var.rg_name
  server_name = azurerm_mysql_flexible_server.serverformation1.name
    start_ip_address = "0.0.0.0"
    end_ip_address = "255.255.255.255"
    depends_on = [ azurerm_mysql_flexible_server.serverformation1, 
    azurerm_mysql_flexible_database.mysqldb1 ] 
}
