
## is SQL installed
if(Get-Service *sql* -cn dscsvr2) {
    ## Uninstall SQL Server
    invoke-command -ComputerName dscsvr2 -ScriptBlock {
        C:\temp\2019\Setup.exe /ACTION=Uninstall /FEATURES=SQLENGINE /INSTANCENAME=MSSQLSERVER /Q
        #double hop issue
        #\\DC\Share\Software\SQLServer\2019\Setup.exe /ACTION=Uninstall /FEATURES=SQLENGINE /INSTANCENAME=MSSQLSERVER /Q
    }
}

## remove firewall rule - not working in SqlServerDsc module
Get-NetFirewallRule -CimSession dscsvr2 -DisplayName *SQL* | Remove-NetFirewallRule

[DSCLocalConfigurationManager()]
configuration LCMConfig
{
    Node dscsvr2
    {
        Settings
        {
            ConfigurationModeFrequencyMins = 15
            RebootNodeIfNeeded = $false
        }
    }
}

## Invoke meta configuration
LCMConfig -Output .\output\

## Apply configuration
Set-DscLocalConfigurationManager -Path .\output\ -ComputerName dscsvr2 -Verbose -Force

Configuration ResetServer {
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node DscSvr2 {
        WindowsFeature RemoveDotNet {
            Name = 'NET-Framework-Features'
            Ensure = 'Absent'
        }
        WindowsFeature RemoveADPosh {
            Name = 'RSAT-AD-PowerShell'
            Ensure = 'Absent'
        }

        File RemoveInstallDir {
            DestinationPath = "C:\SQL2019\Install\"
            Ensure          = 'Absent'
            Type            = 'Directory'
            Force           = $true
        }
        File RemoveDataDir {
            DestinationPath = "C:\SQL2019\SQLData\"
            Ensure          = 'Absent'
            Type            = 'Directory'
            Force           = $true
        }
        File RemoveLogsDir {
            DestinationPath = "C:\SQL2019\SQLLogs\"
            Ensure          = 'Absent'
            Type            = 'Directory'
            Force           = $true
        }
        File RemoveSql2019Dir {
            DestinationPath = "C:\SQL2019\"
            Ensure          = 'Absent'
            Type            = 'Directory'
            Force           = $true
        }
        File RemoveSql2016 {
            DestinationPath = "C:\SQL2016\"
            Ensure          = 'Absent'
            Type            = 'Directory'
            Force           = $true
        }
    }
}

ResetServer -Output .\output\

Start-DscConfiguration -Path .\output\ -ComputerName DscSvr2 -Wait -Verbose -force

Restart-Computer dscsvr2 -Force

## Empty Output folder
Remove-Item .\output\*


## Test it
Import-Module Pester -RequiredVersion 4.9.0
Invoke-Pester .\tests\*