@{
    AllNodes = @(
        @{
            NodeName = "DSCSVR1"
            Environment = "Test"
        },
        @{
            NodeName = "DSCSVR2"
            Environment = "Production"
        },
        @{
            NodeName = '*'
            PSDscAllowPlainTextPassword = $true
        }
    )
    NonNodeData = @{
        DataDir         = "C:\SQL2019\SQLData\"
        LogDir          = "C:\SQL2019\SQLLogs\"
        InstallDir      = "C:\SQL2019\Install\"
        InstanceDir     = "C:\SQL2019\Instance\"
        TempDbDataDir   = "C:\SQL2019\TempDbData\"
        TempDbLogDir    = "C:\SQL2019\TempDbLogs\"

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
