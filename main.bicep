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

@description('The start and end IP address of the firewall rule. Must be IPv4 format. Use value 0.0.0.0 for all Azure-internal IP addresses.')
param firewallAdresses object = {
  endIpAddress: '0.0.0.0'
  startIpAddress: '0.0.0.0'
}


@description('Deploy param for KeyVault')
param deploy bool = true


param projectName string = 'revolv'

@allowed([
  'prod'
  'dev'
])
param Environment string = 'prod'

// Define the names for resources.
var staticAppName = 'appfrontend${projectName}${Environment}001'
var appServiceAppName = 'app-backend-${projectName}${Environment}001'
var appServicePlanName = 'plan${projectName}${Environment}'
var sqlServerName = 'sql-${projectName}${Environment}'
var sqlDatabaseName = 'sqldb-${projectName}${Environment}'
var storageAccountName = 'st${projectName}${Environment}003'
var keyVaultName = 'kv${projectName}${Environment}002'


module appPlan 'modules/appplan.bicep' = {
  name: 'appPlanDeploy'
  params: {
    appServicePlanName: appServicePlanName
    appServicePlanSkuName: appServicePlanSkuName
    location: location
  }
}
module app 'modules/app.bicep' = {
  name: 'appDeploy'
  params: {
    appServicePlanId: appPlan.outputs.appServicePlanId
    appServiceAppName: appServiceAppName
    location: location
    connectionStringValue: 'Server=tcp:${sqlServerName}${environment().suffixes.sqlServerHostname},1433;Initial Catalog=${sqlDatabaseName};User Id=${sqlServerAdministratorLogin};Password=${sqlServerAdministratorLoginPassword};'
  }
  dependsOn: [
    sqldb
  ]
}

module sqlserver 'modules/sqlserver.bicep' = {
  name: 'sqlserverDeploy'
  params: {
    location: location
    sqlServerAdministratorLogin: sqlServerAdministratorLogin
    sqlServerAdministratorLoginPassword: sqlServerAdministratorLoginPassword
    sqlServerName: sqlServerName
    firewallAdresses : firewallAdresses

  }
}

module sqldb 'modules/sqldb.bicep' = {
  name: 'databaseDeploy'
  params: {
    sqlDatabaseName: '${sqlServerName}/${sqlDatabaseName}'
    location: location
  }
  dependsOn: [
    sqlserver
  ]
 } 

module storageAcc 'modules/storage.bicep' = {
  name: 'storageDeploy'
  params: {
    location: location
    storageAccountName: storageAccountName
    storageAcessTier : (Environment == 'prod') ? 'Hot' : 'Cool'
  }
}

module staticApp 'modules/staticapp.bicep' = {
  name: 'staticAppDeploy'
  params: {
    location: location
    staticAppName: staticAppName
  }

}

module keyVault 'modules/keyvault.bicep' = if (deploy) {
  name: 'keyVaultDeploy'
  params: {
    location: location
    keyvaultName: keyVaultName
  }
}

module secrets 'modules/secrets.bicep' = {
  name: 'secretDeploy'
  params: {
    keyvaultName: keyVaultName
    sqlDatabaseName: sqlDatabaseName
    sqlServerAdministratorLogin: sqlServerAdministratorLogin
    sqlServerAdministratorLoginPassword: sqlServerAdministratorLoginPassword
    sqlServerName: sqlServerName
    storageAccountName: storageAccountName
  }
  dependsOn: [
    keyVault
    storageAcc
    sqldb
    app
  ]  
}


