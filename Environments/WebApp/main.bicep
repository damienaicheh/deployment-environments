// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

@description('Name of the Web App')
param name string = ''

@description('Location to deploy the environment resources')
param location string = resourceGroup().location

var resourceName = !empty(name) ? replace(name, ' ', '-') : 'a${uniqueString(resourceGroup().id)}'

@description('Tags to apply to environment resources')
param tags object = {}

var hostingPlanName = '${resourceName}-plan'
var webAppName = '${resourceName}-web-${uniqueString(resourceGroup().id)}', 0, 4)'

resource hostingPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: hostingPlanName
  location: location
  sku: {
    tier: 'Basic'
    name: 'B1'
  }
  tags: tags
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: location
  kind: "app,linux"
  properties: {
    serverFarmId: hostingPlan.id
  }
  tags: union(tags, {
    azd-service-name: 'api'
  })
}
