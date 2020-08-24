@{
    AllNodes = @(
        @{
            NodeName = "DSCSVR1"
            Environment = "Test"
        }
    )
    NonNodeData = @{
        DataDir = "C:\SQL2019\SQLData\"
        LogDir = "C:\SQL2019\SQLLogs\"
        TestDir = "C:\TestForJess"
    }
}

## 1) Add a node
## 2) Change folders to SQL2017
