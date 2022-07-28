
@description('Location for all resources.')
param location string = resourceGroup().location

@description('VNet name')
param vnetName string = 'VNet1'

@description('Address prefix')
param vnetAddressPrefix string = '10.0.0.0/16'

var subnets = [
  {
    name: 'frontEndSubnet'
    subnetPrefix : '10.0.1.0/24'
  }
  {
    name: 'middleSubnet'
    subnetPrefix : '10.0.2.0/24'
  }
  {
    name: 'backEndSubnet'
    subnetPrefix : '10.0.3.0/24'
  }
  {
    name: 'DMZSubnet'
    subnetPrefix : '10.0.4.0/24'
  }
]


resource vnet 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [for sub in subnets: {
      name: sub.name
      properties: {
        addressPrefix: sub.subnetPrefix
      }
    }]
  }

  resource subnet 'subnets' existing = [for sub in subnets: {
    name: sub.name
  }]

}

output frontendSubnetId string = vnet::subnet[0].id
output middleSubnetId string = vnet::subnet[1].id
output backendSubnetId string = vnet::subnet[2].id
output dmzSubnetId string = vnet::subnet[3].id

