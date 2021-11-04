@maxLength(13)
param instanceName string
param tags object
param adminUserName string

@secure()
param adminPassword string
@allowed([
  8
  16
  24
  32
  40
  64
])
param vCores int 
@allowed([
  'GeneralPurpose'
  'BusinessCritical'
])
param tier string = 'GeneralPurpose'
param licenseType string = 'LicenseIncluded'
param virtualNetworkName string = 'sqlmi-vnet'
param addressPrefix string = '10.0.0.0/16'
param subnetName string = 'ManagedInstance'
param subnetPrefix string = '10.0.0.0/24'

var networkSecurityGroupName = 'SQLMI-${instanceName}-NSG'
var routeTableName = 'SQLMI-${instanceName}-Route-Table'

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: networkSecurityGroupName
  location: resourceGroup().location
  properties: {
    securityRules: [
      {
        name: 'allow_tds_inbound'
        properties: {
          description: 'Allow access to data'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '1433'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
        }
      }
      {
        name: 'allow_redirect_inbound'
        properties: {
          description: 'Allow inbound redirect traffic to Managed Instance inside the virtual network'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '11000-11999'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1100
          direction: 'Inbound'
        }
      }
      {
        name: 'deny_all_inbound'
        properties: {
          description: 'Deny all other inbound traffic'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 4096
          direction: 'Inbound'
        }
      }
      {
        name: 'deny_all_outbound'
        properties: {
          description: 'Deny all other outbound traffic'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 4096
          direction: 'Outbound'
        }
      }
    ]
  }
}

resource routeTable 'Microsoft.Network/routeTables@2021-02-01' = {
  name: routeTableName
  location: resourceGroup().location
  properties: {
    disableBgpRoutePropagation: false
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: virtualNetworkName
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
          routeTable: {
            id: routeTable.id
          }
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
          delegations: [
            {
              name: 'managedInstanceDelegation'
              properties: {
                serviceName: 'Microsoft.Sql/managedInstances'
              }
            }
          ]
        }
      }
    ]
  }
}


resource symbolicname 'Microsoft.Sql/managedInstances@2021-02-01-preview' = {
  name: instanceName
  location: resourceGroup().location
  tags: tags
  sku: {
    name: 'vCore'
    tier: tier
  }
  properties: {
    administratorLogin: adminUserName
    administratorLoginPassword: adminPassword
    licenseType: licenseType
    vCores: vCores
    subnetId: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)
  }
}
