# Invoke-Command -ComputerName DSCSVR2 -ScriptBlock {Get-Service *SQL*}

## 1) Look at MOF File
## 2) Config file
## 3) Walk through Configuration

Configuration InstallSqlServer {

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName SqlServerDsc

    $saCred = (Get-Credential -Credential sa)

    Node $AllNodes.NodeName {
        #WindowsFeature InstallDotNet {
        #    Name                = 'NET-Framework-Features'
        #    Ensure              = 'Present'
        #}

        jpSqlFolderStructure createSQLFolders {
            InstallPath        = $ConfigurationData.NonNodeData.InstallDir
            InstancePath       = $ConfigurationData.NonNodeData.InstanceDir
            UserDataPath       = $ConfigurationData.NonNodeData.DataDir
            UserLogPath        = $ConfigurationData.NonNodeData.LogDir
            TempDbDataPath     = $ConfigurationData.NonNodeData.TempDbDataDir
            TempDbLogPath      = $ConfigurationData.NonNodeData.TempDbLogDir
        }

        SqlSetup InstallSql {
            InstanceName        = 'MSSQLSERVER'
            SourcePath          = '\\DC\Share\Software\SQLServer\2019\'
            Features            = 'SQLEngine'
            SQLSysAdminAccounts = 'pomfret\jpomfret'
            SQLUserDBDir        = $ConfigurationData.NonNodeData.DataDir
            SQLUserDBLogDir     = $ConfigurationData.NonNodeData.LogDir
            InstallSharedDir    = $ConfigurationData.NonNodeData.InstallDir
            InstanceDir         = $ConfigurationData.NonNodeData.InstanceDir
            SQLTempDBDir        = $ConfigurationData.NonNodeData.TempDbDataDir
            SQLTempDBLogDir     = $ConfigurationData.NonNodeData.SQLTempDBLogDir
            SecurityMode        = 'SQL'
            SAPwd               = $saCred
        }

        SqlServerNetwork EnableTcpIp {
            DependsOn           = '[SqlSetup]InstallSql'
            InstanceName        = 'MSSQLSERVER'
            ProtocolName        = 'Tcp'
            IsEnabled           = $true
            TCPPort             = 1433
            RestartService      = $true
        }

        SqlWindowsFirewall AllowFirewall {
            DependsOn           = '[SqlSetup]InstallSql'
            InstanceName        = 'MSSQLSERVER'
            Features            = 'SQLEngine'
            SourcePath          = '\\DC\Share\Software\SQLServer\2019\'
        }

        $ConfigurationData.NonNodeData.ConfigOptions.foreach{
            SqlConfiguration ("SetConfigOption{0}" -f $_.name) {
                DependsOn       = '[SqlSetup]InstallSql'
                ServerName      = $Node.NodeName
                InstanceName    = 'MSSQLSERVER'
                OptionName      = $_.Name
                OptionValue     = $_.Setting
            }
        }

        SqlDatabase CreateDbaDatabase {
            DependsOn           = '[SqlSetup]InstallSql'
            ServerName          = $Node.NodeName
            InstanceName        = 'MSSQLSERVER'
            Name                = 'DBA'
        }
    }
}

## 1) DependsOn
## 2) PsDscRunAsCredential
## 3) sa password
## 4) make a change - rerun

InstallSqlServer -Output .\Output\ -ConfigurationData .\05_SqlServer_ConfigData.psd1

Start-DscConfiguration -Path .\Output\ -ComputerName DscSvr2 -Wait -Verbose -Force