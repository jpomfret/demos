Configuration InstallSqlServer {
 
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName SqlServerDsc
 
    Node $AllNodes.NodeName {
        WindowsFeature InstallDotNet {
            Name                = 'NET-Framework-Features'
            Ensure              = 'Present'
        }

        File CreateInstallDir {
            DestinationPath     = $ConfigurationData.NonNodeData.InstallDir
            Ensure              = 'Present'
            Type                = 'Directory'
        }
        File CreateInstanceDir {
            DestinationPath     = $ConfigurationData.NonNodeData.InstanceDir
            Ensure              = 'Present'
            Type                = 'Directory'
        }
        File CreateDataDir {
            DestinationPath     = $ConfigurationData.NonNodeData.DataDir
            Ensure              = 'Present'
            Type                = 'Directory'
        }
        File CreateLogsDir {
            DestinationPath     = $ConfigurationData.NonNodeData.LogDir
            Ensure              = 'Present'
            Type                = 'Directory'
        }

        SqlSetup InstallSql {
            InstanceName        = 'MSSQLSERVER'
            SourcePath          = 'C:\Software\SQLServer2017\'
            Features            = 'SQLEngine'
            SQLSysAdminAccounts = 'domain\jpomfret'
            SQLUserDBDir        = $ConfigurationData.NonNodeData.DataDir
            SQLUserDBLogDir     = $ConfigurationData.NonNodeData.LogDir
            InstallSharedDir    = $ConfigurationData.NonNodeData.InstallDir
            InstanceDir         = $ConfigurationData.NonNodeData.InstanceDir
        }
        
        SqlServerNetwork EnableTcpIp {
            InstanceName        = 'MSSQLSERVER'
            ProtocolName        = 'Tcp'
            IsEnabled           = $true
            TCPPort             = 1433
            RestartService      = $true
        }
        
        SqlWindowsFirewall AllowFirewall {
            InstanceName        = 'MSSQLSERVER'
            Features            = 'SQLEngine'
            SourcePath          = 'C:\Software\SQLServer2017\'
        }

        $ConfigurationData.NonNodeData.ConfigOptions.foreach{
            SqlServerConfiguration ("SetConfigOption{0}" -f $_.name) {
                ServerName      = $Node.NodeName  ## node?!?
                InstanceName    = 'MSSQLSERVER'
                OptionName      = $_.Name
                OptionValue     = $_.Setting
            }
        }

        SqlDatabase CreateDbaDatabase {
            ServerName          = $Node.NodeName #$AllNodes.NodeName  ## node?!?
            InstanceName        = 'MSSQLSERVER'
            Name                = 'DBA'
        }
    }
}

$configData = @{
    AllNodes = @(
        @{
            NodeName = "DSCSVR1"
            Environment = "Test"
        },
        @{
            NodeName = "DSCSVR2"
            Environment = "Production"
        }
    )
    NonNodeData = @{
        DataDir = "C:\SQL2017\SQLData\"
        LogDir = "C:\SQL2017\SQLLogs\"
        InstallDir = "C:\SQL2017\Install\"
        InstanceDir =  "C:\SQL2017\Instance\"
        ConfigOptions = @(
            @{
                Name    = "backup compression default"
                Setting = 1
            },
            @{
                Name    = "cost threshold for parallelism"
                Setting = 25
            },
            @{
                Name    = "max degree of parallelism"
                Setting = 4
            }
        )
    }
}

InstallSqlServer -Output .\Output\ -ConfigurationData $configData

Start-DscConfiguration -Path .\Output\ -ComputerName DscSvr2 -Wait -Verbose -Force