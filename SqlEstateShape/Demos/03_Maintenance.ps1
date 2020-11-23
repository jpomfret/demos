Import-Module dbatools

$SqlInstances = 'mssql1','mssql2','mssql3'

Invoke-DbcCheck -SqlInstance $SqlInstances -Check $MaintChecks -Show Fails
<#
Tests completed in 13.49s
Tests Passed: 14, Failed: 31, Skipped: 0, Pending: 0, Inconclusive: 0 
#>

Find-DbaCommand *ola*

Get-Help Install-DbaMaintenanceSolution -ShowWindow

$maintInstall = @{
    SqlInstance = $SqlInstances
    InstallJobs = $true
    LogToTable  = $true
    Solution    = 'All' # Valid values are All (full solution), Backup, IntegrityCheck and IndexOptimize.
}
Install-DbaMaintenanceSolution @maintInstall
# or local file - should probably have file saved somewhere for backup

# Run the full backups
Get-DbaAgentJob -SqlInstance $SqlInstances -Category 'Database Maintenance' |
Out-GridView -PassThru |
Start-DbaAgentJob

# Run the Integrity Checks
Get-DbaAgentJob -SqlInstance $SqlInstances -Category 'Database Maintenance' |
Where-Object Name -like 'DatabaseIntegrityCheck*' |
Start-DbaAgentJob |
Select-Object SqlInstance, Name

# second time to compare?
Invoke-DbcCheck -SqlInstance $SqlInstances -Check $MaintChecks -Show Fails

# Rerun the health check - 1:17

# 40:00