@description('The Azure region into which the resources should be deployed.')
param location string = resourceGroup().location

@description('The name of the App Service app.')
param appServiceAppName string

@description('The name of the App Service plan.')
param appServicePlanName string

@description('The name of the App Service plan SKU.')
param appServicePlanSkuName string

@description('The amount of the App Service app.')
param appCount int

param tags object = {}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  tags: tags
  sku: {
    name: appServicePlanSkuName
  }
}

resource appServiceApp 'Microsoft.Web/sites@2022-03-01' =  [for i in range(1, appCount): {
  name: '${appServiceAppName}${i}'
  location: location
  tags: tags
  properties: {
    serverFarmId: appServicePlan.id
  }
}]

