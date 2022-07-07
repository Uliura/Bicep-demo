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


param appNames array = [
  'front'
  'back'
]

param dbCount int = 2


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
module app 'modules/app.bicep' = [for name in appNames: {
  name: 'appDeploy${name}'
  params: {
    appServicePlanId: appPlan.outputs.appServicePlanId
    appServiceAppName: '${appServiceAppName}-${name}'
    location: location
  }
}]

module sqlserver 'modules/sqlserver.bicep' = [for i in range(1, dbCount): {
  name: 'sqlserverDeploy${i}'
  params: {
    location: location
    sqlServerAdministratorLogin: sqlServerAdministratorLogin
    sqlServerAdministratorLoginPassword: sqlServerAdministratorLoginPassword
    sqlServerName: '${sqlServerName}${i}'
  }
}]

module sqldb 'modules/sqldb.bicep' = {
  name: 'databaseDeploy'
  params: {
    sqlDatabaseName: sqlDatabaseName
    location: location
  }  
} 

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

