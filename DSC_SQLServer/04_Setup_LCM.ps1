## Get Current settings
Get-DscLocalConfigurationManager -CimSession dscsvr2

Get-DscLocalConfigurationManager -CimSession dscsvr2  |
Select-Object ActionAfterReboot, RefreshMode, ConfigurationModeFrequencyMins, @{l='SourcePath';e={$_.ResourceModuleManagers.SourcePath}}

## Write the meta configuration
[DSCLocalConfigurationManager()]
configuration LCMConfig
{
    Node dscsvr2
    {
        Settings
        {
            ConfigurationID = $(New-Guid).Guid
            ActionAfterReboot = 'ContinueConfiguration'
            RefreshMode = 'Push'
            ConfigurationModeFrequencyMins = 20

        }

        ResourceRepositoryShare FileShare
        {
            SourcePath = '\\dc\share\DSCResources\LCM'
        }
    }
}

## Invoke meta configuration
LCMConfig -Output .\output\

## Apply configuration
Set-DscLocalConfigurationManager -Path .\output\ -ComputerName dscsvr2 -Verbose

## Get New settings
Get-DscLocalConfigurationManager -CimSession dscsvr2  |
Select-Object ActionAfterReboot, RefreshMode, ConfigurationModeFrequencyMins, @{l='SourcePath';e={$_.ResourceModuleManagers.SourcePath}}