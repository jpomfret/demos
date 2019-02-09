
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
    Node DscSvr2 {
        WindowsFeature RemoveDotNet {
            Name = 'NET-Framework-Features'
            Ensure = 'Absent'
        }
        WindowsFeature RemoveADPosh {
            Name = 'RSAT-AD-PowerShell'
            Ensure = 'Absent'
        }
    }
}

ResetServer -output .\output\

Start-DscConfiguration -Path .\output\ -ComputerName DscSvr2 -Wait -Verbose