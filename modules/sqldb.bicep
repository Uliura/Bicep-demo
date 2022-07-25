@description('The Azure region into which the resources should be deployed.')
param location string = resourceGroup().location

@description('The name and tier of the SQL database SKU.')
param sqlDatabaseSku object = {
  name: 'Standard'
  tier: 'Standard'
}

@description('The name of the SQL Database.')
param sqlDatabaseName string


resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-11-01-preview' = {
  name: sqlDatabaseName
  location: location
  sku: sqlDatabaseSku
}
