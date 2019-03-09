Configuration CreateSqlFolder {

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $AllNodes.NodeName {
        File CreateDataDir {
            DestinationPath = $ConfigurationData.NonNodeData.DataDir
            Ensure          = 'Present'
            Type            = 'Directory'
        }
        File CreateLogDir {
            DestinationPath = $ConfigurationData.NonNodeData.LogDir
            Ensure          = 'Present'
            Type            = 'Directory'
        }
    }

    Node $AllNodes.Where{$_.Environment -eq "Test"}.NodeName {
        File CreateTestDir {
            DestinationPath = 'C:\test'
            Ensure          = 'Present'
            Type            = 'Directory'
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
        DataDir = "C:\SQL2016\SQLData\"
        LogDir = "C:\SQL2016\SQLLogs\"
    }
}

CreateSqlFolder -Output .\Output\  -ConfigurationData $configData

