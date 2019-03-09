Configuration SQLServerPreReq {
 
    Import-DscResource -ModuleName PSDesiredStateConfiguration
 
    Node 'DscSvr2' {
        WindowsFeature dotNet
        {
            Name                    = 'NET-Framework-Features'
            Ensure                  = 'Present'
            IncludeAllSubFeature    = $true
            Source                  = "D:\Sources\sxs"
        }
        WindowsFeature ADPowershell 
        {
            Name                    = 'RSAT-AD-PowerShell'
            Ensure                  = 'Present'
            IncludeAllSubFeature    = $true
            Source                  = "D:\Sources\sxs"
        }
    }
}
SQLServerPreReq -Output .\Output\ 

Start-DscConfiguration -Path .\Output\ -ComputerName DscSvr2 -Wait -Verbose