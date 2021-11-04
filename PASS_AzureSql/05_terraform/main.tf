provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "PASSdemo"
  location = "UK South"
}

resource "azurerm_mssql_server" "example" {
  name                         = "jesssqlserver7"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_mssql_database" "test" {
  name           = "tfdb"
  server_id      = azurerm_mssql_server.example.id
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