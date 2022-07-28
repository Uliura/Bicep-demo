param location string = resourceGroup().location
param skuName string = 'Standard'
param skuTier string = 'Standard'
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
    provider: 'None'
  }
}

