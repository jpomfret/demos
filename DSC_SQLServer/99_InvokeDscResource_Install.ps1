# copied SqlServer module and SqlServerDsc modules out to dscsvr2 - could we just update PsModulePath for the sessoin?
$env:PSModulePath += ';\\dc\Share\Modules\'
Import-Module PSDesiredStateConfiguration
# $creds = Get-Credential

$resources = @{
    Name = 'Service'
    ModuleName = 'PSDesiredStateConfiguration'
    Property = @{
        Name  = 'VSS'
        State = 'Stopped'
    }
}, @{
    Name = 'SqlSetup'
    ModuleName = (@{ModuleName='SqlServerDsc'; RequiredVersion='15.1.1'})
    Property = @{
        InstanceName        = 'MSSQLSERVER'
        SourcePath          = '\\DC\Share\Software\SQLServer\2019\'
        Features            = 'SQLEngine'
        SQLSysAdminAccounts = 'pomfret\jpomfret','pomfret\administrator'
        SQLUserDBDir        = "C:\SQL2019\SQLData\"
        SQLUserDBLogDir     = "C:\SQL2019\SQLLogs\"
        InstallSharedDir    = "C:\SQL2019\Install\"
        InstanceDir         = "C:\SQL2019\Instance\"
        SQLTempDBDir        = "C:\SQL2019\TempDbData\"
        SQLTempDBLogDir     = "C:\SQL2019\TempDbLogs\"
        SecurityMode        = 'SQL'
        SAPwd               = $creds
    }
},@{
    Name = 'SqlDatabase'
    ModuleName = (@{ModuleName='SqlServerDsc'; RequiredVersion='15.1.1'})
    Property = @{
        InstanceName='MSSQLSERVER'
        Name='test'
    }
}
$resources.foreach{
    try {
        Write-Host $psitem.Name
        if(!(Invoke-DscResource @psitem -Method Test).InDesiredState) {
            Write-Host ('Set for {0}' -f $psitem.Name)
            Invoke-DscResource @psitem -Method Set
        }
    } catch{
        Write-Output "Ran into an issue: $($PSItem.Exception.Message)"
    }
}

