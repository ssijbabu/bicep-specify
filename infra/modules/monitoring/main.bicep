@description('Log Analytics workspace name')
param lawName string
@description('Region')
param location string = 'nznorth'
@description('Tags')
param tags object = {}

resource law 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: lawName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
  tags: tags
}

output workspaceId string = law.id
