@description('Role assignment scope id')
param scopeId string
@description('Principal id to assign role to')
param principalId string
@description('Role definition id or built-in role name')
param role string

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(scopeId, principalId, role)
  properties: {
    roleDefinitionId: role
    principalId: principalId
  }
}

output roleAssignmentId string = roleAssignment.id
