configuration JSqlDbaDatabase {
    param (
        $Version
    )

    Import-DscResource -ModuleName SqlServerDsc

    node dscsvr2 {
        SqlDatabase CreateDbaDatabase {
            ServerName          = $Env:ComputerName
            InstanceName        = 'SQL1'
            Name                = 'DBA'
        }
        SqlLogin CreateOwnerLogin {
            ServerName          = $Env:ComputerName
            InstanceName        = 'SQL1'
            Name                = 'DatabaseOwner'  
            Log  
        }
    }
}