
## is SQL installed
if(Get-Service *sql* -cn dscsvr2) {   
    ## Uninstall SQL Server
    invoke-command -ComputerName dscsvr2 -ScriptBlock { 
        C:\Software\SQLServer2017\Setup.exe /ACTION=Uninstall /FEATURES=SQLENGINE /INSTANCENAME=MSSQLSERVER /Q
    }
}

## remove firewall rule - not working in SqlServerDsc module
Get-NetFirewallRule -CimSession dscsvr2 -DisplayName *SQL* | Remove-NetFirewallRule

Configuration ResetServer {
    Import-DscResource -ModuleName PSDesiredStateConfiguration
 
    Node DscSvr2 {
        WindowsFeature RemoveDotNet {
            Name = 'NET-Framework-Features'
            Ensure = 'Present'
        }
        WindowsFeature RemoveADPosh {
            Name = 'RSAT-AD-PowerShell'
            Ensure = 'Present'
        }

        File RemoveInstallDir {
            DestinationPath = "C:\SQL2017\Install\"
            Ensure          = 'Absent'
            Type            = 'Directory'
            Force           = $true
        }
        File RemoveDataDir {
            DestinationPath = "C:\SQL2017\SQLData\"
            Ensure          = 'Absent'
            Type            = 'Directory'
            Force           = $true
        }
        File RemoveLogsDir {
            DestinationPath = "C:\SQL2017\SQLLogs\"
            Ensure          = 'Absent'
            Type            = 'Directory'
            Force           = $true
        }
        File RemoveSql2017Dir {
            DestinationPath = "C:\SQL2017\"
            Ensure          = 'Absent'
            Type            = 'Directory'
            Force           = $true
        }
    }
}

ResetServer -Output .\output\

Start-DscConfiguration -Path .\output\ -ComputerName DscSvr2 -Wait -Verbose

## Empty Output folder
Remove-Item .\output\*