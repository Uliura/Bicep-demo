@description('Network security group name')
param nsgName string

@description('Network security group location')
param location string = resourceGroup().location

@description('Array containing security rules. For properties format refer to https://docs.microsoft.com/en-us/azure/templates/microsoft.network/networksecuritygroups?tabs=bicep#securityrulepropertiesformat')
param securityRules array = [
  {
    name: 'DenyAll_In'
    properties: {
      description: 'Deny All incoming traffic'
      protocol: '*'
      sourcePortRange: '*'
      destinationPortRange: '*'
      sourceAddressPrefix: '*'
      destinationAddressPrefix: '*'
      access: 'Deny'
      priority: 4096
      direction: 'Inbound'
    }
  }
  {
    name: 'DenyAll_out'
    properties: {
      description: 'Deny all outcoming traffic'
      protocol: '*'
      sourcePortRange: '*'
      destinationPortRange: '*'
      sourceAddressPrefix: '*'
      destinationAddressPrefix: '*'
      access: 'Deny'
      priority: 4096
      direction: 'Outbound'
    }
  }
]


resource nsg 'Microsoft.Network/networkSecurityGroups@2022-01-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [for rule in securityRules: {
      name: rule.name
      properties: rule.properties
    }]
  }
}
output nsgName string = nsg.name
output nsgId string = nsg.id
