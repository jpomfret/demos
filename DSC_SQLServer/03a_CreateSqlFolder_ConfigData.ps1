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
}

$configData = @{
    AllNodes = @(
        @{
            NodeName = "DSCSVR1"
        },
        @{
            NodeName = "DSCSVR2"
        }
    )
    NonNodeData = @{
        DataDir = "C:\SQL2016\SQLData\"
        LogDir = 'C:\SQL2016\SQLLogs\'
    }
}

CreateSqlFolder -Output .\Output\  -ConfigurationData $configData

## 1) Add a node
## 2) Add LogDir to NonNodeData
## 3) Change folders to SQL2016

## Cleanup
Remove-Item .\Output\*.Mof