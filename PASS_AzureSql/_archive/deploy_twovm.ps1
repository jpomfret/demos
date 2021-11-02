Set-Location C:\github\demos\PASS_AzureSql\bicep

$resourceGroupName = 'clusterRg'

# deploy AD 
# https://github.com/Azure/azure-quickstart-templates/tree/master/application-workloads/active-directory/active-directory-new-domain

# I use the SecretsManagement PowerShell module to store my secrets which can be installed with `Install-Module SecretManagement`. I add secrets with `Set-Secret -Name nameofsecret -Secret secretvalue`.
# You will need to change this for your own environment
#$admincredentials = New-Object System.Management.Automation.PSCredential ((Get-Secret -Name beardmi-benadmin-user -AsPlainText), (Get-Secret -Name beardmi-benadmin-pwd))

<# #>
# if you do not store them in secrets management use this
$admincredentials = New-Object System.Management.Automation.PSCredential ('jpomfret ', (ConvertTo-SecureString -String 'P@ssword1234!' -AsPlainText -Force))

# ad noonewillknow@2

$date = Get-Date -Format yyyyMMddHHmmsss
$deploymentname = 'deploy_VM_{0}_{1}' -f $ResourceGroupName, $date # name of the deployment seen in the activity log


$deploymentConfig = @{
    resourceGroupName  = $resourceGroupName  
    Name               = $deploymentname
    TemplateFile       = 'vm.bicep' 
    virtualMachineName = 'sql1'
    osDiskType         = 'Premium_LRS'
    virtualMachineSize = 'Standard_DS3_v2'
    adminUsername      = $admincredentials.UserName
    adminPassword      = $admincredentials.Password
    publisher          = 'MicrosoftSQLServer'
    offer              = 'sql2019-ws2019'
    sku                = 'SQLDEV'
    version            = 'latest'
    tags               = @{
        dbatoolslab = $true
        clusterNode = $true
    }
}
New-AzResourceGroupDeployment @deploymentConfig

$deploymentname = 'deploy_VM_{0}_{1}' -f $ResourceGroupName, $date # name of the deployment seen in the activity log
$deploymentConfig = @{
    resourceGroupName  = $resourceGroupName  
    Name               = $deploymentname
    TemplateFile       = 'vm.bicep' 
    virtualMachineName = 'sql2'
    osDiskType         = 'Premium_LRS'
    virtualMachineSize = 'Standard_DS3_v2'
    adminUsername      = $admincredentials.UserName
    adminPassword      = $admincredentials.Password
    publisher          = 'MicrosoftSQLServer'
    offer              = 'sql2019-ws2019'
    sku                = 'SQLDEV'
    version            = 'latest'
    tags               = @{
        dbatoolslab = $true
        clusterNode = $true
    }
}
New-AzResourceGroupDeployment @deploymentConfig