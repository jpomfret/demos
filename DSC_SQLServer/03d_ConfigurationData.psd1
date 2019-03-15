@{
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
        DataDir = "C:\SQL2016\SQLData\"
        LogDir = "C:\SQL2016\SQLLogs\"
        TestDir = "C:\TestForJess"
    }
}
