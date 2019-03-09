Configuration CompositeSQLServerPreReq {
 
    Import-DscResource -ModuleName PSDesiredStateConfiguration
 
    Node 'DscSvr2' {
        WindowsFeatureSet prereqs
        {
            Name                    = @('NET-Framework-Features',
                                        'RSAT-AD-PowerShell')
            Ensure                  = 'Present'
            IncludeAllSubFeature    = $true
            Source                  = "D:\Sources\sxs"
        }
    }
}
 
CompositeSQLServerPreReq -Output .\Output\ 

Start-DscConfiguration -Path .\Output\ -ComputerName DscSvr2 -Wait -Verbose