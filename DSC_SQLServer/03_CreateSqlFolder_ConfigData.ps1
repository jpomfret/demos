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
            DestinationPath = $ConfigurationData.NonNodeData.TestDir
            Ensure          = 'Present'
            Type            = 'Directory'
        }
    }
}

CreateSqlFolder -Output .\Output\  -ConfigurationData .\03a_ConfigurationData.psd1

## Cleanup
# Remove-Item .\Output\*.Mof