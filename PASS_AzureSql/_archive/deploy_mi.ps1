
Set-Location C:\github\demos\PASS_AzureSql\bicep


$resourceGroupName = 'PASSdemo'
$sqlMIName = 'ben-aks-mi' # max 13 characters - name of the instance
$dataControllerName = 'ben-aks-cluster-dc' # the name of the data controller deployed with deploy-dc.ps1
$customLocationName = 'ben-aks-cluster-location'# the name of the custom location deployed with create-aks.ps1
# I use the SecretsManagement PowerShell module to store my secrets which can be installed with `Install-Module SecretManagement`. I add secrets with `Set-Secret -Name nameofsecret -Secret secretvalue`.
# You will need to change this for your own environment
#$admincredentials = New-Object System.Management.Automation.PSCredential ((Get-Secret -Name beardmi-benadmin-user -AsPlainText), (Get-Secret -Name beardmi-benadmin-pwd))

<# #>
# if you do not store them in secrets management use this
$admincredentials = New-Object System.Management.Automation.PSCredential ('jpomfret ', (ConvertTo-SecureString -String 'P@ssword1234!' -AsPlainText))


$date = Get-Date -Format yyyyMMddHHmmsss
$deploymentname = 'deploy_sqlmi_{0}_{1}' -f $sqlMIName, $date # name of the deployment seen in the activity log
$deploymentConfig = @{
    resourceGroupName        = $resourceGroupName  
    Name                     = $deploymentname
    TemplateFile             = 'sql-mi.bicep' 
    instancename             = $sqlMIName
    dataControllerId         = $dataControllerName
    customLocation           = $customLocationName
    adminUserName            = $admincredentials.UserName
    adminPassword            = $admincredentials.Password
    namespace                = 'arc'
    serviceType              = 'LoadBalancer'
    cpuRequest               = '2'  # Yes its a string dont hate me vCores settings for instance
    cpuLimit                 = '8'  # Yes its a string dont hate me vCores settings for instance
    memoryRequest            = '16Gi' # Yes its a string dont hate me Memory settings for instance
    memoryLimit              = '32Gi' # Yes its a string dont hate me Memory settings for instance
    dataStorageSize          = '15Gi'
    dataStorageClassName     = 'default' # dont change this for AKS deployments
    logsStorageSize          = '15Gi'
    logsStorageClassName     = 'default' # dont change this for AKS deployments
    dataLogsStorageSize      = '15Gi'
    dataLogsStorageClassName = 'default' # dont change this for AKS deployments
    backupsStorageSize       = '15Gi'
    backupsStorageClassName  = 'default' # dont change this for AKS deployments
    replicas                 = 3 # 1 or 3 - number of replicas to create
    tier                     = 'GeneralPurpose' # BusinessCritical or GeneralPurpose
    licenseType              = 'LicenseIncluded' # LicenseIncluded or BasePrice
    isDev                    = $true # is this a dev instance true or false
    tags                     = @{
        Important    = 'This is controlled by Bicep'
        creator      = 'The Beard'
        project      = 'For Ben'
        BenIsAwesome = $true
    }
}
New-AzResourceGroupDeployment @deploymentConfig # -WhatIf  # uncomment what if to see "what if" !!