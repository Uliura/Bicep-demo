@description('The Azure region into which the resources should be deployed.')
param location string = resourceGroup().location

@secure()
@description('The administrator login username for the SQL server.')
param sqlServerAdministratorLogin string

@secure()
@description('The administrator login password for the SQL server.')
param sqlServerAdministratorLoginPassword string

@description('The start and end IP address of the firewall rule. Must be IPv4 format. Use value 0.0.0.0 for all Azure-internal IP addresses.')
param firewallAdresses object = {}

param tags object = {}

@description('The name of the SQL logical server.')
param sqlServerName string

resource sqlServer 'Microsoft.Sql/servers@2021-11-01-preview' = {
  name: sqlServerName
  location: location
  tags: tags
  properties: {
    administratorLogin: sqlServerAdministratorLogin
    administratorLoginPassword: sqlServerAdministratorLoginPassword
  }
  resource sqlFirewallRule 'firewallRules@2021-11-01-preview' = {
    name: 'string'
    properties: firewallAdresses
  }
}
