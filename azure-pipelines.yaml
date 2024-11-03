name: Azure Pipelines

# Start with a minimal pipeline that you can customize to build and deploy your code.
# Add steps that build, run tests, deploy, and more:
# https://aka.ms/yaml
trigger:
- main

# ToDo: Replace the agent pool name, if you are using Udacity Cloud lab. 
# Otherwise comment out the line below. 
pool: myAgentPool

variables:
  python.version: '3.7.17'
  # ToDo: Replace the service connection name as used in the DevOps project settings
  azureServiceConnectionId: 'myServiceConnection'
  # Project root folder. Point to the folder containing manage.py file.
  projectRoot: $(System.DefaultWorkingDirectory)
  # Environment name
  environmentName: 'test'

stages:
- stage: ProvisionInfrastructure
  jobs:
  - job: BuildInfrastructure
    steps:
    - checkout: self
    - script: ls -la $(System.DefaultWorkingDirectory)/terraform/environments/test
    #displayName: 'List files in Terraform directory'
    # Install Terraform on the pipeline agent 
    # Install Azure CLI on the pipeline agent 
    - task: Bash@3
      displayName: 'Install Azure CLI'
      inputs:
        targetType: 'inline'
        script: |
          curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

    - task: Bash@3
      displayName: 'Terrafom installation'
      inputs:
        targetType: 'inline'
        script: |
          sudo apt-get update
          sudo apt-get install -y gnupg software-properties-common
          wget -O- https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
          sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
          sudo apt-get update
          sudo apt-get install terraform
    
    # Azure CLI Login
    - task: AzureCLI@2
      displayName: 'Azure CLI Login'
      inputs:
        azureSubscription: '$(azureServiceConnectionId)' # Use your service connection name
        scriptType: 'bash'
        scriptLocation: 'inlineScript'
        inlineScript: |
          echo "Logged in to Azure"

    # Run Terraform Init on the pipeline agent 
    # ToDo: Replace the resource group name, storage account name, and container name below
    - task: Bash@3
      displayName: 'Terrafom init'
      inputs:
        targetType: 'inline'
        script: |
          cd $(System.DefaultWorkingDirectory)/terraform/environments/test
                terraform init -backend-config="resource_group_name=Azuredevops" \
                               -backend-config="storage_account_name=tfstate21172" \
                               -backend-config="container_name=tfstate" \
                               -backend-config="key=test.terraform.tfstate"
        # provider: 'azurerm'
        # command: 'init'
        # workingDirectory: '$(System.DefaultWorkingDirectory)/terraform/environments/test'
        # backendServiceArm: '$(azureServiceConnectionId)'
        # backendAzureRmResourceGroupName: 'Azuredevops'
        # backendAzureRmStorageAccountName: 'tfstate21172'
        # backendAzureRmContainerName: 'tfstate'
        # backendAzureRmKey: 'test.terraform.tfstate'
        

    # Run Terraform Plan    
    - task: Bash@3
      displayName: Terraform Plan
      inputs:
        # provider: 'azurerm'
        # command: 'validate'
        targetType: 'inline'
        script: |
          terraform -chdir=$(System.DefaultWorkingDirectory)/terraform/environments/test plan

    
    # Run Terraform Apply
    # ToDo: Change the workingDirectory path, as applicable to you
    - task: Bash@3
      displayName: Terraform apply
      inputs:
        targetType: 'inline'
        script: |
          terraform -chdir=$(System.DefaultWorkingDirectory)/terraform/environments/test apply -auto-approve
        # provider: 'azurerm'
        # command: 'apply'
        # workingDirectory: '$(System.DefaultWorkingDirectory)/terraform/environments/test'
        # environmentServiceNameAzureRM: '$(azureServiceConnectionId)'

    # Destroy the resources in Azure
    # ToDo: Change the workingDirectory path, as applicable to you
    # - task: Bash@3
    #   displayName: Terraform destroy
    #   inputs:
    #     targetType: 'inline'
    #     script: |
    #       terraform -chdir=$(System.DefaultWorkingDirectory)/terraform/environments/test destroy -auto-approve
        # provider: 'azurerm'
        # command: 'destroy'
        # workingDirectory: '$(System.DefaultWorkingDirectory)/terraform/environments/test'
        # environmentServiceNameAzureRM: '$(azureServiceConnectionId)'        
- stage: Build
displayName: Build
jobs:
- job: Build
  pool:
    name: Hosted Ubuntu 1604
  steps:
  #Needed for Terraform VM deployment
  - task: InstallSSHKey@0
    inputs:
      knownHostsEntry: 'KNOWN_HOSTS_STRING'
      sshPublicKey: 'PUBLIC_KEY'
      sshKeySecureFile: 'id_rsa.pub'
  - task: ArchiveFiles@2
    displayName: 'Archive FakeRestAPI'
    inputs:
      rootFolderOrFile: '$(System.DefaultWorkingDirectory)/fakerestapi'
      includeRootFolder: false
      archiveType: 'zip'
      archiveFile: '$(Build.ArtifactStagingDirectory)/$(Build.BuildId)-fakerestapi.zip'
  - publish: $(Build.ArtifactStagingDirectory)/$(Build.BuildId)-fakerestapi.zip
    displayName: 'Upload Package'
    artifact: drop-fakerestapi
  - task: ArchiveFiles@2
    displayName: 'Archive files'
    inputs:
      rootFolderOrFile: '$(System.DefaultWorkingDirectory)/automatedtesting/selenium'
      includeRootFolder: false
      archiveType: zip
      archiveFile: $(Build.ArtifactStagingDirectory)/selenium-tests.zip
      replaceExistingArchive: true
  - upload: $(Build.ArtifactStagingDirectory)/selenium-tests.zip
    artifact: selenium

- stage: WebAppDeployment
displayName: Web App Deployment
jobs:
- deployment: FakeRestAPI
  pool:
    vmImage: 'Ubuntu-16.04'
  environment: 'WAP-TEST'
  strategy:
    runOnce:
      deploy:
        steps:
        - task: AzureWebApp@1
          displayName: 'Deploy Azure Web App'
          inputs:
            azureSubscription: 'EnsuringQualityReleasesSC'
            appType: 'webApp'
            appName: 'WAS-EQR'
            package: '$(Pipeline.Workspace)/drop-fakerestapi/$(Build.BuildId)-fakerestapi.zip'
            deploymentMethod: 'auto'
- deployment: VMDeploy
  displayName: VM Deploy
  environment:
    name:  'VM-TEST'
    resourceType: VirtualMachine
  strategy:
    runOnce:
      deploy:
        steps:
        - task: Bash@3
          displayName: 'Install Dependencies'
          inputs:
            targetType: 'inline'
            script: |
              #! /bin/bash
              
              sudo apt-get upgrade -y
              sudo apt-get install python3-pip -y
              sudo apt-get install unzip -y
              sudo apt-get install -y chromium-browser
              pip3 install selenium
              
              # download chrome driver
              FILE=chromedriver_linux64.zip
              if [ -f "$FILE" ]; then
                echo "$FILE exists."
              else
                wget https://chromedriver.storage.googleapis.com/2.41/chromedriver_linux64.zip
              fi
              # install chrome driver
              unzip chromedriver_linux64.zip
              sudo mv chromedriver /usr/bin/chromedriver
              sudo chown root:root /usr/bin/chromedriver
              sudo chmod +x /usr/bin/chromedriver
              chromium-browser -version
              chromedriver --version
              # agent log analytics
              wget https://raw.githubusercontent.com/Microsoft/OMS-Agent-for-Linux/master/installer/scripts/onboard_agent.sh && sh onboard_agent.sh -w dbf2bd83-6d47-436b-a499-a2b566def8fe -s MuSR8Ti5MMi0E+9+1NM4NxCxFqJcfLzuGD0EtGhjXo3Vhy/THcSdCf1WyQnkXafD+6DiFjiOAEfJiQh6EbZVeg== -d opinsights.azure.com

        - download: current
          displayName: 'Download Selenium'
          artifact: selenium
        - task: Bash@3
          displayName: UI Tests
          inputs:
            targetType: 'inline'
            script: |
              unzip -o $(Pipeline.Workspace)/selenium/selenium-tests.zip -d .
              sudo mkdir /var/logs
              python3 uitests.py > ui-logs.log
              sudo mv ui-logs.log /var/logs
