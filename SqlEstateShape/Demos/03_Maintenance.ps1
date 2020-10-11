Import-Module dbatools

$SqlInstances = 'mssql1','mssql2','mssql3'

Invoke-DbcCheck -SqlInstance $SqlInstances -Check $MaintChecks -Show Fails
<#
Tests completed in 15.6s
Tests Passed: 17, Failed: 37, Skipped: 0, Pending: 0, Inconclusive: 0
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

Get-DbaAgentJob -SqlInstance $SqlInstances -Category 'Database Maintenance' | Out-GridView -PassThru | Start-DbaAgentJob

# 40:00

# second time to compare?
Invoke-DbcCheck -SqlInstance $SqlInstances -Check $MaintChecks -Show Fails
