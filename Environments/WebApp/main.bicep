@description('Name of the Web App')
param name string = ''

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Tags to apply to environment resources')
param tags object = {}

var resourceName = ((!empty(name))
  ? replace(name, ' ', '-')
  : 'a${uniqueString(resourceGroup().id)}')
var hostingPlanName = '${resourceName}-hp'
var webAppName = '${resourceName}-web-${substring(uniqueString(resourceGroup().id),0,4)}'
var customTag = {
  'azd-service-name': 'api'
}

resource hostingPlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: hostingPlanName
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
    size: 'B1'
    family: 'B'
    capacity: 1
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2023-01-01' = {
  name: webAppName
  location: location
  properties: {
    httpsOnly: true
    serverFarmId: hostingPlan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|8.0'
      minTlsVersion: '1.2'
      ftpsState: 'FtpsOnly'
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
  tags: union(tags, customTag)
}
