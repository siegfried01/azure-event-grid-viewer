/*
   Begin common prolog commands
   export name=azure-event-grid-viewer
   export rg=rg_${name}
   export loc=westus2
   End common prolog commands

   emacs F10
   Begin commands to deploy this file using Azure CLI with bash
   echo WaitForBuildComplete
   WaitForBuildComplete
   echo az deployment group create --mode complete --template-file ./clear-resources.json --resource-group $rg
   az deployment group create --mode complete --template-file ./clear-resources.json --resource-group $rg
   echo "Previous build is complete. Begin deployment build."
   echo az deployment group create --name $name --resource-group $rg   --mode  Incremental  --template-file  deploy-azure-event-grid-viewer.bicep
   az deployment group create --name $name --resource-group $rg   --mode  Incremental  --template-file  deploy-azure-event-grid-viewer.bicep
   echo end deploy
   az resource list -g $rg --query "[?resourceGroup=='$rg'].{ name: name, flavor: kind, resourceType: type, region: location }" --output table
   End commands to deploy this file using Azure CLI with bash

   emacs ESC 2 F10
   Begin commands to shut down this deployment using Azure CLI with bash
   echo CreateBuildEvent.exe
   CreateBuildEvent.exe&
   echo "begin shutdown"
   az deployment group create --mode complete --template-file ./clear-resources.json --resource-group $rg
   #echo az group delete -g $rg  --yes 
   #az group delete -g $rg  --yes 
   BuildIsComplete.exe
   az resource list -g $rg --query "[?resourceGroup=='$rg'].{ name: name, flavor: kind, resourceType: type, region: location }" --output table
   echo "showdown is complete"
   End commands to shut down this deployment using Azure CLI with bash

   emacs ESC 3 F10
   Begin commands for one time initializations using Azure CLI with bash
   az group create -l $loc -n $rg
   export id=`az group show --name $rg --query 'id' --output tsv`
   echo "id=$id"
   #export sp="spad_$name"
   #az ad sp create-for-rbac --name $sp --sdk-auth --role contributor --scopes $id
   #echo "go to github settings->secrets and create a secret called AZURE_CREDENTIALS with the above output"
   if [[ -e clear-resources.json ]]
   then
   echo clear-resources.json already exists
   else
   cat >clear-resources.json <<EOF
   {
    "\$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
     "contentVersion": "1.0.0.0",
     "resources": [] 
   }
   EOF
   fi
   End commands for one time initializations using Azure CLI with bash

 */
param location string = resourceGroup().location
param name string = uniqueString(resourceGroup().id)
@description('The name of the web app that you wish to create.')
param siteName string = '${name}-web'

@description('The name of the App Service plan to use for hosting the web app.')
param hostingPlanName string = '${name}-plan'

@description('The pricing tier for the hosting plan.')
@allowed([
  'F1'
  'D1'
  'B1'
  'B2'
  'B3'
  'S1'
])
param sku string = 'F1'

@description('The URL for the GitHub repository that contains the project to deploy.')
param repoURL string = 'https://github.com/siegfried01/SourceControlsAzureBicepDemo03.git'
//param repoURL string = 'https://github.com/siegfried01/AADB2CBlazorSvrRoleBasedAuthorization.git'
//param repoURL string = 'https://github.com/siegfried01/BlazorSvrGitPlay.git'
//param repoURL string = 'https://github.com/siegfried01/azure-event-grid-viewer.git'
//param repoURL string = 'https://github.com/Azure-Samples/azure-event-grid-viewer.git'

@description('The branch of the GitHub repository to use.')
param branch string = 'main'

resource hostingPlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: hostingPlanName
  location: location
  sku: {
    name: sku
    capacity: 0
  }
  //kind: ''
  properties: {
    name: hostingPlanName
  }
}

resource site 'Microsoft.Web/sites@2020-12-01' = {
  name: siteName
  location: location
  properties: {
    serverFarmId: hostingPlanName
    siteConfig: {
      webSocketsEnabled: true
      //netFrameworkVersion: 'v6.0'
      windowsFxVersion: 'DOTNETCORE|6'
      metadata: [
        {
          name: 'CURRENT_STACK'
          value: 'dotnet'
        }
      ]
    }
    httpsOnly: true
  }
  dependsOn: [
    hostingPlan
  ]
}

resource siteName_web 'Microsoft.Web/sites/sourcecontrols@2020-12-01' = {
  parent: site
  name: 'web'
  properties: {
    repoUrl: repoURL
    branch: branch
    isManualIntegration: true
  }
}

output appServiceEndpoint string = 'https://${site.properties.hostNames[0]}'
