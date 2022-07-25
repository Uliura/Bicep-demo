@description('The Azure region into which the resources should be deployed.')
param location string = resourceGroup().location

param tags object = {}
@maxLength(24)
@minLength(3)
param storageAccountName string 

param storageAccountSkuName string = 'Standard_LRS'

param storageAcessTier string 

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  location: location
  tags: tags
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: storageAcessTier
  }
}

