@description('Spoke name')
param spokeName string
@description('Spoke prefix (CIDR)')
param spokePrefix string
@description('Hub VNet id')
param hubId string
@description('Region')
param location string = 'nznorth'
@description('Tags')
param tags object = {}

resource spokeVnet 'Microsoft.Network/virtualNetworks@2023-02-01' = {
  name: '${spokeName}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [spokePrefix]
    }
    subnets: [
      {
        name: 'app'
        properties: {
          addressPrefix: '${spokePrefix[0]}'
        }
      }
    ]
  }
  tags: tags
}

// Note: peering will be implemented by caller providing hubId and handling permissions

output spokeVnetId string = spokeVnet.id
