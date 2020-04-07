$securePassword = ('Password1234!' | ConvertTo-SecureString -asPlainText -Force)
$credential = New-Object System.Management.Automation.PSCredential('sa', $securePassword)

$migrateDbSplat = @{
    Source                   = "mssql1"
    SourceSqlCredential      = $Credential
    Destination              = 'mssql2'
    DestinationSqlCredential = $Credential
    Database                 = "AdventureWorks2017"
    BackupRestore            = $true
    SharedPath               = '/sharedpath'
    Verbose                  = $true
}
Copy-DbaDatabase @migrateDbSplat -NewName AdventureWorks2019

backup-dbadatabase -SqlInstance mssql2  -SqlCredential $credential -ExcludeDatabase AdventureWorks2019
backup-dbadatabase -SqlInstance mssql2  -SqlCredential $credential -ExcludeDatabase AdventureWorks2019 -Type Diff
backup-dbadatabase -SqlInstance mssql2  -SqlCredential $credential -ExcludeDatabase AdventureWorks2019 -Type Log
backup-dbadatabase -SqlInstance mssql1 -SqlCredential $credential -Database DatabaseAdmin

New-DbaAgentJob -SqlInstance mssql2 -SqlCredential $credential -Job DailyReport
New-DbaAgentJobStep -SqlInstance mssql2 -SqlCredential $credential -Job DailyReport -StepName Step1 -Subsystem TransactSql -Command 'Select Missing Table'
Start-DbaAgentJob -SqlInstance mssql2 -SqlCredential $credential -Job DailyReport

New-DbaAgentJob -SqlInstance mssql1 -SqlCredential $credential -Job ImportantETLJob
New-DbaAgentJobStep -SqlInstance mssql1 -SqlCredential $credential -Job ImportantETLJob -StepName Step1 -Subsystem TransactSql -Command 'Select Missing Table'
Start-DbaAgentJob -SqlInstance mssql1 -SqlCredential $credential -Job ImportantETLJob

$securePassword = ('Password1234!' | ConvertTo-SecureString -asPlainText -Force)
$badCredential = New-Object System.Management.Automation.PSCredential('WrongUser', $securePassword)
Connect-DbaInstance -SqlInstance mssql1 -SqlCredential $badCredential

Import-Module dbatools

$servers = Get-DbaRegisteredServer -Group Sqlserver

Get-DbaLastBackup -SqlInstance $servers |
Format-Table SqlInstance, Database, LastFullBackup, LastDiffBackup, LastLogBackup

Get-DbaLastBackup -SqlInstance $servers |
Where-Object {($_.LastFullBackup.Date -lt ((Get-Date).AddDays(-7))) `
-or ($_.LastDiffBackup.Date -lt ((Get-Date).AddDays(-1))) `
-or ($_.RecoveryModel -eq 'Full' -and $_.LastLogBackup.Date -lt ((Get-Date).AddHours(-1)))} |
Format-Table SqlInstance, Database, LastFullBackup, LastDiffBackup, LastLogBackup, RecoveryModel -AutoSize

    -or ($_.RecoveryModel -eq 'Full' -and $_.LastLogBackup.Date -lt ((Get-Date).AddHours(-1))) } |
Get-DbaLastGoodCheckDb -SqlInstance $servers |
Select-Object SqlInstance, Database, DaysSinceLastGoodCheckDb, Status, DataPurityEnabled |
Where-Object Status -ne 'OK' |
Format-Table


Get-DbaAgentJob -SqlInstance $servers -ExcludeDisabledJobs |
Where-Object LastRunOutcome -ne 'Succeeded' |
Format-Table SqlInstance, Name, LastRunDate, LastRunOutcome

Get-DbaErrorLog -SqlInstance $servers -After (get-date).AddDays(-1) |
Format-Table SqlInstance, SqlInstance, Source, Text

Get-DbaErrorLog -SqlInstance $servers -After (get-date).AddDays(-1) -Text "Login Failed" |
Format-Table SqlInstance, SqlInstance, Source, Text
