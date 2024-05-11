param location string = resourceGroup().location
param name string = uniqueString(resourceGroup().id)

param sites_eventgridviewer_web_name string = '${name}-web'
param serverfarms_eventgridviewer_plan_name string = '${name}-plan'

resource serverfarms_eventgridviewer_plan_name_resource 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: serverfarms_eventgridviewer_plan_name
  location: location
  sku: {
    name: 'F1'
    tier: 'Free'
    size: 'F1'
    family: 'F'
    capacity: 0
  }
  kind: 'app'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

resource sites_eventgridviewer_web_name_resource 'Microsoft.Web/sites@2022-09-01' = {
  name: sites_eventgridviewer_web_name
  location: location
  kind: 'app'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${sites_eventgridviewer_web_name}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${sites_eventgridviewer_web_name}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: serverfarms_eventgridviewer_plan_name_resource.id
    reserved: false
    isXenon: false
    hyperV: false
    vnetRouteAllEnabled: false
    vnetImagePullEnabled: false
    vnetContentShareEnabled: false
    siteConfig: {
      numberOfWorkers: 1
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: false
      functionAppScaleLimit: 0
      minimumElasticInstanceCount: 0
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: true
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    customDomainVerificationId: '40BF7B86C2FCFDDFCAF1DB349DF5DEE2661093DBD1F889FA84ED4AAB4DA8B993'
    containerSize: 0
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    redundancyMode: 'None'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}

resource sites_eventgridviewer_web_name_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-09-01' = {
  parent: sites_eventgridviewer_web_name_resource
  name: 'ftp'
  properties: {
    allow: true
  }
}

resource sites_eventgridviewer_web_name_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-09-01' = {
  parent: sites_eventgridviewer_web_name_resource
  name: 'scm'
  properties: {
    allow: true
  }
}

resource sites_eventgridviewer_web_name_web 'Microsoft.Web/sites/config@2022-09-01' = {
  parent: sites_eventgridviewer_web_name_resource
  name: 'web'
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
      'hostingstart.html'
    ]
    netFrameworkVersion: 'v6.0'
    phpVersion: '5.6'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    httpLoggingEnabled: false
    acrUseManagedIdentityCreds: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    publishingUsername: '$eventgridviewer-web'
    scmType: 'ExternalGit'
    use32BitWorkerProcess: true
    webSocketsEnabled: true
    alwaysOn: false
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: false
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    vnetRouteAllEnabled: false
    vnetPrivatePortsCount: 0
    localMySqlEnabled: false
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: false
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'FtpsOnly'
    preWarmedInstanceCount: 0
    elasticWebAppScaleLimit: 0
    functionsRuntimeScaleMonitoringEnabled: false
    minimumElasticInstanceCount: 0
    azureStorageAccounts: {}
  }
}

resource sites_eventgridviewer_web_name_426440ffa752ab0bb2fdd052fe989717827e2ae7 'Microsoft.Web/sites/deployments@2022-09-01' = {
  parent: sites_eventgridviewer_web_name_resource
  name: '426440ffa752ab0bb2fdd052fe989717827e2ae7'
  properties: {
    status: 4
    author_email: 'dabarkol@microsoft.com'
    author: 'David Barkol'
    deployer: 'GitHub'
    message: 'Merge pull request #21 from dbarkol/main\n\nUpgrade to .NET Core 6.0'
    start_time: '2023-05-19T18:44:20.445519Z'
    end_time: '2023-05-19T18:45:20.3752385Z'
    active: true
  }
}

resource sites_eventgridviewer_web_name_sites_eventgridviewer_web_name_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2022-09-01' = {
  parent: sites_eventgridviewer_web_name_resource
  name: '${sites_eventgridviewer_web_name}.azurewebsites.net'
  properties: {
    siteName: 'eventgridviewer-web'
    hostNameType: 'Verified'
  }
}
