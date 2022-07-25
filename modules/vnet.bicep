@description('VNet name')
param vnetName string = 'VNet1'

@description('Address prefix')
param vnetAddressPrefix string = '10.0.0.0/16'

@description('Subnet 1 Prefix')
param subnet1Prefix string = '10.0.0.0/24'

@description('Subnet 1 Name')
param subnet1Name string = 'frontEndSubnet'

@description('Subnet 2 Prefix')
param subnet2Prefix string = '10.0.1.0/24'

@description('Subnet 2 Name')
param subnet2Name string = 'middleSubnet'

@description('Subnet 3 Prefix')
param subnet3Prefix string = '10.0.2.0/24'

@description('Subnet 3 Name')
param subnet3Name string = 'backEndSubnet'

@description('Subnet 4 Prefix')
param subnet4Prefix string = '10.0.3.0/24'

@description('Subnet 4 Name')
param subnet4Name string = 'DMZSubnet'

@description('Location for all resources.')
param location string = resourceGroup().location

resource vnet 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: subnet1Prefix
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: subnet2Prefix
        }
      }
      {
        name: subnet3Name
        properties: {
          addressPrefix: subnet3Prefix
        }
      }
      {
        name: subnet4Name
        properties: {
          addressPrefix: subnet4Prefix
        }
      }
    ]
  }
  resource subnet1 'subnets' existing = {
    name: subnet1Name
  }

  resource subnet2 'subnets' existing = {
    name: subnet2Name
  }
  resource subnet3 'subnets' existing = {
    name: subnet3Name
  }

  resource subnet4 'subnets' existing = {
    name: subnet4Name
  }
}
output frontendSubnetId string = vnet::subnet1.id
output middleSubnetId string = vnet::subnet2.id
output backendSubnetId string = vnet::subnet3.id
output dmzSubnetId string = vnet::subnet4.id
