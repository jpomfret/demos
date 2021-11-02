Set-Location C:\github\demos\PASS_AzureSql\bicep

$resourceGroupName = 'clusterRg'

# I use the SecretsManagement PowerShell module to store my secrets which can be installed with `Install-Module SecretManagement`. I add secrets with `Set-Secret -Name nameofsecret -Secret secretvalue`.
# You will need to change this for your own environment
#$admincredentials = New-Object System.Management.Automation.PSCredential ((Get-Secret -Name beardmi-benadmin-user -AsPlainText), (Get-Secret -Name beardmi-benadmin-pwd))

<# #>
# if you do not store them in secrets management use this
$admincredentials = New-Object System.Management.Automation.PSCredential ('jpomfret', (ConvertTo-SecureString -String 'P@ssword1234!' -AsPlainText -Force))


$date = Get-Date -Format yyyyMMddHHmmsss
$deploymentname = 'deploy_db_{0}_{1}' -f $ResourceGroupName, $date # name of the deployment seen in the activity log
$deploymentConfig = @{
    resourceGroupName  = $resourceGroupName  
    Name               = $deploymentname
    TemplateFile       = 'sql-db.bicep' 
    serverName         = 'JessSqlServer7'
    databaseName       = 'JessDb7'
    sku                = 'Standard'
    autoPauseMin       = 10
    licenseType        = 'BasePrice'
    adminUserName            = $admincredentials.UserName
    adminPassword            = $admincredentials.Password
    tags               = @{
        Important    = 'This is controlled by Bicep'
        creator      = 'The Beard'
        project      = 'For Ben'
        BenIsAwesome = $true
    }
}

New-AzResourceGroupDeployment @deploymentConfig # -WhatIf  # uncomment what if to see "what if" !!