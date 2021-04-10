## Discover locally installed Resources
Get-DscResource -Module PSDesiredStateConfiguration

Get-DscResource -Name File -Syntax
<#
    File [String] #ResourceName
    {
        DestinationPath = [string]
        [Attributes = [string[]]{ Archive | Hidden | ReadOnly | System }]
        [Checksum = [string]{ CreatedDate | ModifiedDate | SHA-1 | SHA-256 | SHA-512 }]
        [Contents = [string]]
        [Credential = [PSCredential]]
        [DependsOn = [string[]]]
        [Ensure = [string]{ Absent | Present }]
        [Force = [bool]]
        [MatchSource = [bool]]
        [PsDscRunAsCredential = [PSCredential]]
        [Recurse = [bool]]
        [SourcePath = [string]]
        [Type = [string]{ Directory | File }]
    }
#>

## Look at what makes up a script resource 
Get-DscResource -Name Service -Module PSDesiredStateConfiguration | Select-Object *
code C:\Windows\system32\WindowsPowershell\v1.0\Modules\PsDesiredStateConfiguration\DSCResources\MSFT_ServiceResource\MSFT_ServiceResource.psm1
## Open Path - look at Get, Test, Set

## Discover resources in the galley
Find-DscResource -Name SqlSetup