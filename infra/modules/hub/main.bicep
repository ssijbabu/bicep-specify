@description('Hub name prefix')
param hubName string
@description('Hub address space (CIDR)')
param addressSpace string = '10.10.0.0/16'
@description('Region for hub')
param location string = 'nznorth'
@description('Tags to apply')
param tags object = {}

resource vnet 'Microsoft.Network/virtualNetworks@2023-02-01' = {
  name: '${hubName}-hub-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [addressSpace]
    }
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: '10.10.0.0/26'
        }
      }
      {
        name: 'platform'
        properties: {
          addressPrefix: '10.10.1.0/24'
        }
      }
    ]
  }
  tags: tags
}

output hubVnetId string = vnet.id
