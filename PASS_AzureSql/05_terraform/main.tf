provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "PASSdemo" {
  name     = "PASSdemo"
  location = "UK South"
}

resource "azurerm_mssql_server" "jesssqlserver" {
  name                         = "jesssqlserver7"
  resource_group_name          = azurerm_resource_group.PASSdemo.name
  location                     = azurerm_resource_group.PASSdemo.location
  version                      = "12.0"
  administrator_login          = "jpomfret"
  administrator_login_password = "P@ssword1234!"
}

resource "azurerm_mssql_database" "tfdb" {
  name           = "tfdb"
  server_id      = azurerm_mssql_server.jesssqlserver.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 4
  read_scale     = true
  sku_name       = "BC_Gen5_2"
  zone_redundant = true

  tags = {
    test      = "true"
    CreatedBy = "terraform"
  }
}