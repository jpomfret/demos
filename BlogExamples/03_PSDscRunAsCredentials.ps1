param (
    $creds
)

Configuration DtcServiceRunning {

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node 'dscsvr2' {
        Service MsDtcRunning {
            Name                 = 'MSDTC'
            Ensure               = 'Present'
            State                = 'Running'
            PsDscRunAsCredential = ($creds)
        }
    }
}

$configData = @{
    AllNodes = @(
        @{
            NodeName = "dscsvr2"
            #PsDscAllowPlainTextPassword = $true ## not recommended outside of testing - should encrypt MOFs
            #PsDscAllowDomainUser = $true    
        }
    )
}

# Generates MOF file
DtcServiceRunning -Output .\Output\ -ConfigurationData $configData

# Apply the configuration
Start-DscConfiguration -Path .\Output\ -ComputerName dscsvr2 -Wait -Verbose