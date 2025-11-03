@description('Key Vault name')
param vaultName string
@description('Location')
param location string = 'nznorth'
@description('Tags')
param tags object = {}

resource kv 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: vaultName
  location: location
  properties: {
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: subscription().tenantId
    accessPolicies: []
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
    }
  }
  tags: tags
}

output keyVaultId string = kv.id
