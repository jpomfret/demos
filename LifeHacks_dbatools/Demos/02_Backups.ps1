###############################
#                             #
#  Testing SQL Server Backups #
#                             #
###############################

$dontDoThis = ('Password1234!' | ConvertTo-SecureString -asPlainText -Force)
$credential = New-Object System.Management.Automation.PSCredential('sa', $dontDoThis)

## Get the backup history for tne mssql1 server
Get-DbaDbBackupHistory -SqlInstance 'mssql1' -SqlCredential $credential

## Backup the DatabaseAdmin database
$backupParams = @{
    SqlInstance = 'mssql1'
    SqlCredential = $credential
    Database = 'DatabaseAdmin'
}
Backup-DbaDatabase @backupParams

## Offload testing your backups to a second server
$testParams = @{
    SqlInstance = 'mssql1'
    SqlCredential = $credential
    Destination = 'mssql2'
    DestinationCredential = $credential
    Verbose = $true
    OutVariable = 'results'
}
Test-DbaLastBackup @testParams

## Record your backup tests into a SQL Server table
$writeParams = @{
    SqlInstance = 'mssql1'
    SqlCredential = $credential
    Database = 'DatabaseAdmin'
    Table = 'TestRestore'
    AutoCreateTable = $true
}
$results | Write-DbaDataTable @writeParams

## Using Piping
Test-DbaLastBackup @testParams | Write-DbaDataTable @writeParams
