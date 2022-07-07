@description('The Azure region into which the resources should be deployed.')
param location string = resourceGroup().location

@description('The name of the App Service app.')
param appServiceAppName string

param sqlDatabaseConnect bool = true

param sqlServerName string
param sqlDatabaseName string

@secure()
@description('The administrator login username for the SQL server.')
param sqlServerAdministratorLogin string

@secure()
@description('The administrator login password for the SQL server.')
param sqlServerAdministratorLoginPassword string

@description('The id of the parent App Service plan.')
param appServicePlanId string

param tags object = {}

resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceAppName
  location: location
  tags: tags
  properties: {
    serverFarmId: appServicePlanId
    
  }
  resource connectionstrings 'config@2022-03-01' = if(sqlDatabaseConnect) {
    name: 'connectionstrings'
    properties: {
      SqlConnection: {
        type: 'SQLAzure'
        value: 'Server=tcp:${sqlServerName}${environment().suffixes.sqlServerHostname},1433;Database=${sqlDatabaseName};User ID=${sqlServerAdministratorLogin};Password=${sqlServerAdministratorLoginPassword}'
      }
    }
  }
}

output appId string = appServiceApp.id
