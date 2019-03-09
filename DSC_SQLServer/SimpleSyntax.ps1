
Configuration CreateSqlFolders {

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node dscsvr2 {
        File CreateDataDir {
            DestinationPath = 'C:\SQL2017\SQLData\'
            Ensure          = 'Present'
            Type            = 'Directory'
        }
        
    }
}

CreateSqlFolders -Output .\Output\ 

#Get-DscResource -Module SqlServerDsc