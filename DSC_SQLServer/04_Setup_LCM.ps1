## Get Current settings
Get-DscLocalConfigurationManager -CimSession dscsvr2

Get-DscLocalConfigurationManager -CimSession dscsvr2  | 
Select-Object ActionAfterReboot, RefreshMode, ConfigurationModeFrequencyMins

## Write the meta configuration
[DSCLocalConfigurationManager()]
configuration LCMConfig
{
    Node dscsvr2
    {
        Settings
        {
            ActionAfterReboot = 'ContinueConfiguration'
            RefreshMode = 'Push'
            ConfigurationModeFrequencyMins = 20
        }
    }
}

## Invoke meta configuration
LCMConfig -Output .\output\

## Apply configuration 
Set-DscLocalConfigurationManager -Path .\output\ -ComputerName dscsvr2 -Verbose

## Get New settings
Get-DscLocalConfigurationManager -CimSession dscsvr2  | 
Select-Object ActionAfterReboot, RefreshMode, ConfigurationModeFrequencyMins

