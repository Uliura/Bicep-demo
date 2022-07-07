@description('The Azure region into which the resources should be deployed.')
param location string = resourceGroup().location

@secure()
@description('The administrator login username for the SQL server.')
param sqlServerAdministratorLogin string

@secure()
@description('The administrator login password for the SQL server.')
param sqlServerAdministratorLoginPassword string

@description('The name and tier of the SQL database SKU.')
param sqlDatabaseSku object = {
  name: 'Standard'
  tier: 'Standard'
}

param tags object = {}

@description('The name of the SQL logical server.')
param sqlServerName string

@description('The name of the SQL Database.')
param sqlDatabaseName string

@description('The amount of the SQL logical server.')
param dbCount int

resource sqlServer 'Microsoft.Sql/servers@2021-11-01-preview' = [for i in range(1, dbCount): {
  name: '${sqlServerName}${i}'
  location: location
  tags: tags
  properties: {
    administratorLogin: sqlServerAdministratorLogin
    administratorLoginPassword: sqlServerAdministratorLoginPassword
  }
}]

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-11-01-preview' = [for i in range(0, dbCount): {
  parent: sqlServer[i]
  name: sqlDatabaseName
  location: location
  sku: sqlDatabaseSku
}]


