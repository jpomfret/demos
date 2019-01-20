Import-Module dbatools

## get config file
$path = Split-Path $MyInvocation.MyCommand.Path
$config = Import-PowerShellDataFile -Path "$path\Config.psd1"

## start up the container with the super secret password (needs to match the dockerfile that attachs databases)
docker run -e ACCEPT_EULA=Y -e SA_PASSWORD=$($config.SAPWD) -p 1433:1433 -d datacompression

## wait for AdventureWorks to be ready

Write-Output ("Running workload from {0}" -f $config.WorkloadFile)
$credential = New-Object System.Management.Automation.PSCredential('sa',($config.SAPWD | ConvertTo-SecureString -asPlainText -Force))
#$null = Invoke-Sqlcmd2 -ServerInstance $config.Instance2017 -Database $config.PrimaryDatabase -InputFile $config.WorkloadFile -ParseGO
$null = Invoke-DbaQuery -SqlInstance $config.Instance2017 -SqlCredential $credential -Database $config.PrimaryDatabase -InputFile $config.WorkloadFile

Write-Output '-----'
Write-Output 'Go filter SSMS for sales schema'