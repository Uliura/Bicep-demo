@description('The location into which your Azure resources should be deployed.')
param location string = resourceGroup().location

@description('The name of the App Service plan SKU.')
param appServicePlanSkuName string = 'B1'

@secure()
@description('The administrator login username for the SQL server.')
param sqlServerAdministratorLogin string

@secure()
@description('The administrator login password for the SQL server.')
param sqlServerAdministratorLoginPassword string


param values array = [
  'Front'
  'Back'
]



// Define the names for resources.
var appServiceAppName = 'gekabicepapp'
var appServicePlanName = 'gekabicepappplan'
var sqlServerName = 'gekabicepsql'
var sqlDatabaseName = 'gekabicepsqldb'
var storageAccountName = 'gekabicepstorage'
var keyVaultName = 'gekaBicepDemoKeyVault'

module appPlan 'modules/appplan.bicep' = {
  name: 'appPlanDeploy'
  params: {
    appServicePlanName: appServicePlanName
    appServicePlanSkuName: appServicePlanSkuName
    location: location
  }
}
module app 'modules/app.bicep' = [for value in values: {
  name: 'appDeploy${value}'
  params: {
    appServicePlanId: appPlan.outputs.appServicePlanId
    appServiceAppName: '${appServiceAppName}-${value}'
    location: location
  }
}]

module sqlserver 'modules/sqlserver.bicep' = [for value in values: {
  name: 'sqlserverDeploy${value}'
  params: {
    location: location
    sqlServerAdministratorLogin: sqlServerAdministratorLogin
    sqlServerAdministratorLoginPassword: sqlServerAdministratorLoginPassword
    sqlServerName: '${sqlServerName}${value}'
  }
}]

module sqldb 'modules/sqldb.bicep' = [for value in values: {
  name: 'databaseDeploy${value}'
  params: {
    sqlDatabaseName: '${sqlServerName}${value}/${sqlDatabaseName}'
    location: location
  }
  dependsOn: [
    sqlserver
  ]
 }] 

 module storageAcc 'modules/storage.bicep' = {
  name: 'storageDeploy'
  params: {
    location: location
    storageAccountName: storageAccountName
  }
}


module keyVault 'modules/keyvault.bicep' = {
  name: 'keyVaultDeploy'
  params: {
    location: location
    keyvaultName: keyVaultName
  }
}

resource webapp 'Microsoft.Web/sites@2022-03-01' existing = [for value in values: {
  name: '${appServiceAppName}-${value}'
 }]

 resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  name: storageAccountName
 }

 resource kVault 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: keyVaultName

 }
 
 resource connectionstrings 'Microsoft.Web/sites/config@2022-03-01' = [for (value, i) in values:{
  parent: webapp[i]
  name: 'connectionstrings'
  properties: {
    SqlConnection: {
      type: 'SQLAzure'
      value: 'Server=tcp:${sqlServerName}${value}${environment().suffixes.sqlServerHostname},1433;Database=${sqlDatabaseName};User ID=${sqlServerAdministratorLogin};Password=${sqlServerAdministratorLoginPassword}'
    }
  }
  dependsOn: [
    app
  ]
}]
