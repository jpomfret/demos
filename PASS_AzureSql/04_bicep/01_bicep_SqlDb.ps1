#Requires -Version 6.0

Set-Location C:\github\demos\PASS_AzureSql\04_bicep

$adminCredentials = New-Object System.Management.Automation.PSCredential ('jpomfret ', (ConvertTo-SecureString -String 'P@ssword1234!' -AsPlainText -Force))

$date = Get-Date -Format yyyyMMddHHmmsss

<# SQL Server & DB #>
$deploymentName = 'deploy_db_{0}_{1}' -f $ResourceGroupName, $date # name of the deployment seen in the activity log
$deploymentConfig = @{
    resourceGroupName  = 'PASSdemo'
    Name               = $deploymentName
    TemplateFile       = 'sql-db.bicep' 
    serverName         = 'JessSqlServer7'
    databaseName       = 'bicepdb'
    sku                = 'GP_Gen5_2'
    tier               = 'GeneralPurpose'
    autoPauseMin       = 10
    licenseType        = 'BasePrice'
    adminUserName      = $adminCredentials.UserName
    adminPassword      = $adminCredentials.Password
    tags               = @{
        Demo        = 'PASS Azure SQL'
        DateCreated = $date
    }
}
New-AzResourceGroupDeployment @deploymentConfig 