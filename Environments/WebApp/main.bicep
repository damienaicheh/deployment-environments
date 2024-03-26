@description('Name of the Web App')
param name string = ''

@description('Location to deploy the environment resources')
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

resource hostingPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: hostingPlanName
  location: location
  kind: 'linux'
  sku: {
    tier: 'Basic'
    name: 'B1'
  }
  tags: tags
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  kind: 'app,linux'
  name: webAppName
  location: location
  properties: {
    serverFarmId: hostingPlan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|8.0'
    }
  }
  tags: union(tags, customTag)
}
