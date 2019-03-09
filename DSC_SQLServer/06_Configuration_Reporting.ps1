## Get the current configuration of the nodes, if a configuration exists
Get-DscConfiguration -CimSession dscsvr2

## Get configuration status for completed runs
Get-DscConfigurationStatus -CimSession dscsvr2 | select *
(Get-DscConfigurationStatus -CimSession dscsvr2).ResourcesInDesiredState

## Test the current configuration
Test-DscConfiguration -ComputerName DscSvr2
