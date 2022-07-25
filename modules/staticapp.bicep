@description('The Azure region into which the resources should be deployed.')
param location string = resourceGroup().location
param staticAppName string
//param repositoryUrl string
//param branch string
//param repositoryToken string

param tags object = {}

resource name_resource 'Microsoft.Web/staticSites@2022-03-01' = {
  name: staticAppName
  location: location
  tags: tags
  properties: {
//    repositoryUrl: repositoryUrl
//    branch: branch
//    repositoryToken: repositoryToken
 }

  sku: {
    tier: 'Standard'
    name: 'Standard'
  }
}

