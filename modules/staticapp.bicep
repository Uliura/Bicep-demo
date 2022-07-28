param location string = resourceGroup().location
param skuName string = 'Free'
param skuTier string = 'Free'
param tags object = {}
param staticAppName string

resource staticWebApp 'Microsoft.Web/staticSites@2022-03-01' = {
  name: staticAppName 
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: skuTier
  }
  properties: {
    // The provider, repositoryUrl and branch fields are required for successive deployments to succeed
    // for more details see: https://github.com/Azure/static-web-apps/issues/516
    provider: 'Other'
    repositoryUrl: ''
    branch: ''

  }
}

