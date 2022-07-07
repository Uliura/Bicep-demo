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


param appCount int = 0
param dbCount int = 0


// Define the names for resources.
var appServiceAppName = 'gekabicepapp'
var appServicePlanName = 'gekabicepappplan'
var sqlServerName = 'gekabicepsql'
var sqlDatabaseName = 'gekabicepsqldb'
var storageAccountName = 'gekabicepstorage'
var keyVaultName = 'gekaBicepDemoKeyVault'



module app 'modules/app.bicep' = {
  name: 'appDeploy'
  params: {
    appServiceAppName: appServiceAppName
    appServicePlanName: appServicePlanName
    appServicePlanSkuName: appServicePlanSkuName
    location: location
    appCount: appCount
  }
}

module databases 'modules/database.bicep' =  {
  name: 'databaseDeploy'
  params: {
    location: location
    sqlServerAdministratorLogin: sqlServerAdministratorLogin
    sqlServerAdministratorLoginPassword: sqlServerAdministratorLoginPassword
    sqlDatabaseName: sqlServerName
    sqlServerName: sqlDatabaseName
    dbCount: dbCount
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

