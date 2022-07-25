@description('Required. Name of the private endpoint resource to create.')
param endpointName string

@description('Required. Resource ID of the subnet where the endpoint needs to be created.')
param subnetResourceId string

@description('Required. Resource ID of the resource that needs to be connected to the network.')
param serviceResourceId string

@description('Required. Subtype(s) of the connection to be created. The allowed values depend on the type serviceResourceId refers to.')
param groupIds array


@description('Optional. Location for all Resources.')
param location string = resourceGroup().location


@description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
param tags object = {}

@description('Optional. Custom DNS configurations.')
param customDnsConfigs array = []

@description('Optional. Manual PrivateLink Service Connections.')
param manualPrivateLinkServiceConnections array = []



resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-08-01' = {
  name: endpointName
  location: location
  tags: tags
  properties: {
    privateLinkServiceConnections: [
      {
        name: endpointName
        properties: {
          privateLinkServiceId: serviceResourceId
          groupIds: groupIds
        }
      }
    ]
    manualPrivateLinkServiceConnections: manualPrivateLinkServiceConnections
    subnet: {
      id: subnetResourceId
    }
    customDnsConfigs: customDnsConfigs
  }
}


@description('The resource ID of the private endpoint.')
output resourceId string = privateEndpoint.id

@description('The name of the private endpoint.')
output endpointName string = privateEndpoint.name
