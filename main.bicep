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



// Define the names for resources.
var appServiceAppName = 'gekabicepapp'
var appServicePlanName = 'gekabicepappplan'
var sqlServerName = 'gekabicepsql'
var sqlDatabaseName = 'gekabicepsqldb'
var storageAccountName = 'gekabicepstorage'




module app 'modules/app.bicep' = {
  name: 'appDeploy'
  params: {
    appServiceAppName: appServiceAppName
    appServicePlanName: appServicePlanName
    appServicePlanSkuName: appServicePlanSkuName
    location: location
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
  }
}

module storageAcc 'modules/storage.bicep' = {
  name: 'storageDeploy'
  params: {
    location: location
    storageAccountName: storageAccountName
  }
}


@description('The host name to use to access the website.')
output websiteHostName string = app.outputs.appServiceAppHostName
