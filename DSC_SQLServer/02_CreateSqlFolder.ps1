Configuration CreateSqlFolder {

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node @('dscsvr1', 'dscsvr2') {
        File CreateDataDir {
            DestinationPath = 'C:\SQL2017\SQLData\'
            Ensure          = 'Present'
            Type            = 'Directory'
        }
        File CreateLogDir {
            DestinationPath = 'C:\SQL2017\SQLLogs\'
            Ensure          = 'Present'
            Type            = 'Directory'
        }
    }
}

# Creates a configuration command 
Get-Command -CommandType Configuration

# Generates 2 MOF files, one for each node
CreateSqlFolder -Output .\Output\ 

## cleanup
Remove-Item .\output\*.mof