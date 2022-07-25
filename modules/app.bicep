@description('The Azure region into which the resources should be deployed.')
param location string = resourceGroup().location

@description('The name of the App Service app.')
param appServiceAppName string

@description('The id of the parent App Service plan.')
param appServicePlanId string

@secure()
param connectionStringValue string

param tags object = {}

resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceAppName
  location: location
  tags: tags
  properties: {
    serverFarmId: appServicePlanId
    
  }
  resource connectionstrings 'config@2022-03-01' = {
    name: 'connectionstrings'
    properties: {
      SqlConnection: {
        type: 'SQLAzure'
        value: connectionStringValue
      }
    }
  }

}
