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
