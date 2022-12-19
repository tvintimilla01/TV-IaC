@sys.description('The Web App name.')
@minLength(3)
@maxLength(30)
param appServiceAppName1 string = 'tvinti-assignment-be-pr'
@sys.description('The Web App name.')
@minLength(3)
@maxLength(30)
param appServiceAppName3 string = 'tvinti-assignment-fe-pr'
@sys.description('The App Service Plan name.')
@minLength(3)
@maxLength(30)
param appServicePlanName1 string = 'tvinti-assignment-pr'
@sys.description('The Web App name.')
@minLength(3)
@maxLength(30)
param appServiceAppName2 string = 'tvinti-assignment-be-dv'
@minLength(3)
@maxLength(30)
param appServiceAppName4 string = 'tvinti-assignment-fe-dv'
@sys.description('The App Service Plan name.')
@minLength(3)
@maxLength(30)
param appServicePlanName2 string = 'tvinti-assignment-dv'
@allowed([
  'nonprod'
  'prod'
  ])
param environmentType string = 'nonprod'
param runtimeStack1 string = 'Python|3.10'
param runtimeStack2 string = 'Node|14-lts'
param startupCommand1 string = 'pm2 serve /home/site/wwwroot/dist --no-daemon --spa'
param location string = resourceGroup().location
@secure()
param dbhost string
@secure()
param dbuser string
@secure()
param dbpass string
@secure()
param dbname string


module appService1 'modules/appStuff.bicep' = if (environmentType == 'prod') {
  name: 'appService1'
  params: { 
    location: location
    appServiceAppName: appServiceAppName1
    appServicePlanName: appServicePlanName1
    runtimeStack: runtimeStack1
    dbhost: dbhost
    dbuser: dbuser
    dbpass: dbpass
    dbname: dbname
  }
}

module appService3 'modules/appStuff2.bicep' = if (environmentType == 'prod') {
  name: 'appService3'
  params: { 
    location: location
    appServiceAppName: appServiceAppName3
    appServicePlanName: appServicePlanName1
    runtimeStack: runtimeStack2
    startupCommand: startupCommand1
  }
}

module appService2 'modules/appStuff.bicep' = if (environmentType == 'nonprod') {
  name: 'appService2'
  params: { 
    location: location
    appServiceAppName: appServiceAppName2
    appServicePlanName: appServicePlanName2
    runtimeStack: runtimeStack1
    dbhost: dbhost
    dbuser: dbuser
    dbpass: dbpass
    dbname: dbname
  }
}

module appService4 'modules/appStuff2.bicep' = if (environmentType == 'nonprod') {
  name: 'appService4'
  params: { 
    location: location
    appServiceAppName: appServiceAppName4
    appServicePlanName: appServicePlanName2
    runtimeStack: runtimeStack2
    startupCommand: startupCommand1
  }
}

  output appServiceAppHostName1 string = (environmentType == 'prod') ? appService1.outputs.appServiceAppHostName : appService2.outputs.appServiceAppHostName
  output appServiceAppHostName2 string = (environmentType == 'prod') ? appService3.outputs.appServiceAppHostName : appService4.outputs.appServiceAppHostName
    