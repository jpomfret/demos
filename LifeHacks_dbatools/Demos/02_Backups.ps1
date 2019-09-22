###############################
#                             #
#  Testing SQL Server Backups #
#                             #
###############################

## Get the backup history for tne mssql1 server
$instanceSplat = @{
    SqlInstance   = 'mssql1'
    SqlCredential = $credential
}
Get-DbaDbBackupHistory @instanceSplat

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
    Database = "AdventureWorks2017","DatabaseAdmin"
    Destination = 'mssql2'
    DestinationCredential = $credential
    Verbose = $true
    OutVariable = 'results'
}
Test-DbaLastBackup @testParams

## Record your backup tests into a SQL Server table
$results | Write-DbaDataTable @writeParams

## Using Piping
Test-DbaLastBackup @testParams | Write-DbaDataTable @writeParams
