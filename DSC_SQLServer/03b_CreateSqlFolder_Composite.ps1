Configuration CreateSqlFolder {

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName CompositeResources

    Node @('dscsvr1', 'dscsvr2') {
        
        jpSqlFolderStructure sqlFolders {
            UserDataPath        = "C:\SQL2019\SQLData\"
            UserLogPath         = "C:\SQL2019\SQLLogs\"
        }
    }
}

# Creates a configuration command
Get-Command -CommandType Configuration

# Generates 2 MOF files, one for each node
CreateSqlFolder -Output .\Output\

## cleanup
#  Remove-Item .\output\*.mof