#Requires -Version 6.0
<# 00_Setup.ps1

- deploys...

#>

Set-Location C:\github\demos\PASS_AzureSql\00_Setup\bicep
$resourceGroupName = 'PASSdemo'

New-AzResourceGroup -Name $resourceGroupName -Location uksouth

# if you do not store them in secrets management use this
$adminCredentials = New-Object System.Management.Automation.PSCredential ('jpomfret', (ConvertTo-SecureString -String 'P@ssword1234!' -AsPlainText -Force))

$date = Get-Date -Format yyyyMMddHHmmsss

<# VM #>
# need to Register SQL Server VM with SQL IaaS Agent Extension
$deploymentName = 'deploy_VM_{0}_{1}' -f $ResourceGroupName, $date # name of the deployment seen in the activity log
$deploymentConfig = @{
    resourceGroupName  = $resourceGroupName  
    Name               = $deploymentName
    TemplateFile       = 'vm.bicep' 
    virtualMachineName = 'sqlOnVm'
    osDiskType         = 'Premium_LRS'
    virtualMachineSize = 'Standard_D8s_v3'
    adminUsername      = $adminCredentials.UserName
    adminPassword      = $adminCredentials.Password
    publisher          = 'MicrosoftSQLServer'
    offer              = 'sql2019-ws2019'
    sku                = 'SQLDEV'
    version            = 'latest'
    tags               = @{
        Demo        = 'PASS Azure SQL'
        DateCreated = $date
    }
}
New-AzResourceGroupDeployment @deploymentConfig # -WhatIf  # uncomment what if to see "what if" !!

# register VM with IaaS Provider for SQL Server
& 'C:\github\demos\PASS_AzureSql\00_Setup\01_Register VM with IaaS Provider.ps1'


# add inbound network security rule
    $myIp = (Invoke-WebRequest -Uri "https://ipv4.icanhazip.com/").Content

    # Get the NSG resource
    $nsg = Get-AzNetworkSecurityGroup -Name sqlOnVm-nsg -ResourceGroupName PASSDemo 

# Add the inbound security rule.
    $nsgSplat = @{
        Name = 'Let Jess in'
        Description = 'Allow rdp & sql ports'
        Access = 'Allow'
        Protocol = '*'
        Direction = 'Inbound'
        Priority = 100
        SourceAddressPrefix = $myIp.trim()
        SourcePortRange = '*'
        DestinationAddressPrefix = '*'
        DestinationPortRange = 3389,1433
    }
    $nsg | Add-AzNetworkSecurityRuleConfig @nsgSplat

    # Update the NSG.
    $nsg | Set-AzNetworkSecurityGroup

<# SQL MI
$sqlMIName = 'sqlMI'
$deploymentName = 'deploy_sqlmi_{0}_{1}' -f $sqlMIName, $date # name of the deployment seen in the activity log
$deploymentConfig = @{
    resourceGroupName        = $resourceGroupName  
    Name                     = $deploymentName
    TemplateFile             = 'sql-mi.bicep' 
    instanceName             = $sqlMIName
    adminUserName            = $adminCredentials.UserName
    adminPassword            = $adminCredentials.Password
    vCores                   = 8
    tier                     = 'GeneralPurpose' # BusinessCritical or GeneralPurpose
    licenseType              = 'LicenseIncluded' # LicenseIncluded or BasePrice
    tags                     = @{
        Demo        = 'PASS Azure SQL'
        DateCreated = $date
    }
}
New-AzResourceGroupDeployment @deploymentConfig 
 #>
<# SQL Server & DB #>
$deploymentName = 'deploy_db_{0}_{1}' -f $ResourceGroupName, $date # name of the deployment seen in the activity log
$deploymentConfig = @{
    resourceGroupName  = $resourceGroupName  
    Name               = $deploymentName
    TemplateFile       = 'sql-db.bicep' 
    serverName         = 'JessSqlServer7'
    databaseName       = 'sqldb'
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


# need to run this in VM PowerShell to let SSMS into SQL!!!
# New-NetFirewallRule -DisplayName 'sqlIn' -Profile Any -Direction Inbound -Action Allow -LocalPort 1433 -Protocol TCP
