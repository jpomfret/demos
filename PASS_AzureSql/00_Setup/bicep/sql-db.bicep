param serverName string
param databaseName string
param tier string
param sku string
param autoPauseMin int
param licenseType string
param tags object
param adminUsername string
@secure()
param adminPassword string


resource sqlserver 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: serverName
  location: resourceGroup().location
  properties: {
    administratorLogin: adminUsername
    administratorLoginPassword: adminPassword
  }
}

resource sqldb 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  name: '${sqlserver.name}/${databaseName}'
  location: resourceGroup().location
  tags: tags
  sku: {
    name: sku
    tier: tier
  }
  properties: {
    autoPauseDelay: autoPauseMin
    licenseType: licenseType
  }
}

