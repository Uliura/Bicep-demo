@secure()
@description('The administrator login username for the SQL server.')
param sqlServerAdministratorLogin string

@secure()
@description('The administrator login password for the SQL server.')
param sqlServerAdministratorLoginPassword string

param sqlDatabaseName string

param storageAccountName string 
param keyvaultName string
param sqlServerName string
param staticAppName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  name: storageAccountName
}

resource keyVault 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: keyvaultName
}

resource staticApp 'Microsoft.Web/staticSites@2022-03-01' existing = {
  name: staticAppName
}

resource sqlSecret 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' =  {
  parent: keyVault
  name: 'sqlSecretDeploy'
  properties: {
    value: 'Server=tcp:${sqlServerName}${environment().suffixes.sqlServerHostname},1433;Database=${sqlDatabaseName};User ID=${sqlServerAdministratorLogin};Password=${sqlServerAdministratorLoginPassword}'
  }

}

resource storageSecret 'Microsoft.KeyVault/vaults/secrets@2021-04-01-preview' = { 
  parent: keyVault
  name: 'storageSecretKey'
  properties: {
    value: storageAccount.listKeys().keys[0].value
  }
}

resource staticAppToken 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = { 
  parent: keyVault
  name: 'staticAppToken'
  properties: {
    value: staticApp.listSecrets().properties.apiKey
  }
}
