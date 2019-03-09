Configuration InstallSqlServer {
 
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName SqlServerDsc
 
    Node 'DscSvr2' {
        File CreateInstallDir {
            DestinationPath = 'C:\SQL2017\Install\'
            Ensure          = 'Present'
            Type            = 'Directory'
        }
        File CreateDataDir {
            DestinationPath = 'C:\SQL2017\SQLData\'
            Ensure          = 'Present'
            Type            = 'Directory'
        }
        File CreateLogsDir {
            DestinationPath = 'C:\SQL2017\SQLLogs\'
            Ensure          = 'Present'
            Type            = 'Directory'
        }

        SqlSetup InstallSql {
            InstanceName    = 'MSSQLSERVER'
            SourcePath      = 'C:\Software\SQLServer2017\'
            Features        = 'SQLEngine'
            SQLSysAdminAccounts = 'domain\jpomfret'
        }
        
        SqlWindowsFirewall AllowFirewall {
            InstanceName    = 'MSSQLSERVER'
            Features        = 'SQLEngine'
            SourcePath      = 'C:\Software\SQLServer2017\'
        }
        
        SqlServerNetwork EnableTcpIp {
            InstanceName    = 'MSSQLSERVER'
            ProtocolName    = 'Tcp'
            IsEnabled       = $true
            TCPPort         = 1433
            RestartService  = $true
        }

    }
}
 
InstallSqlServer -Output .\Output\ 

Start-DscConfiguration -Path .\Output\ -ComputerName DscSvr2 -Wait -Verbose -Force