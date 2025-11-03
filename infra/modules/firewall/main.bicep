@description('Firewall name prefix')
param firewallName string
@description('Firewall SKU (Standard or Premium)')
param sku string = 'Standard'
@description('Region')
param location string = 'nznorth'
@description('Tags')
param tags object = {}

resource pubIp 'Microsoft.Network/publicIPAddresses@2022-09-01' = if (sku == 'Standard') {
  name: '${firewallName}-pip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  tags: tags
}

resource firewall 'Microsoft.Network/azureFirewalls@2022-09-01' = {
  name: firewallName
  location: location
  sku: {
    name: sku
  }
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig'
        properties: {
          publicIPAddress: {
            id: pubIp.id
          }
        }
      }
    ]
  }
  tags: tags
}

output firewallId string = firewall.id
output firewallIp string = pubIp.properties.ipAddress
