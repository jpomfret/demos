Import-Module dbatools

$config = Import-PowerShellDataFile -Path Config.psd1

Write-Output ("Running with Instance: {0}" -f $config.Instance2016 )
Write-Output ("Running with Database: {0}" -f $config.Database )
Write-Output ("Running with BackupFile: {0}" -f $config.Database )

#Remove-DbaDatabase -SqlInstance 