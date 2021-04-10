#######################
#                     #
#  Test Your Backups  #
#                     #
#######################

# Review backup history
# Backup your databases
# Test those backups
# Your backups are useless if they can't be restored
# Save restore testing results to a table

## Get the backup history for the mssql1 server
$instanceSplat = @{
    SqlInstance = 'mssql1'
}
Get-DbaDbBackupHistory @instanceSplat | Sort-Object Start

## Backup the DatabaseAdmin database
$backupParams = @{
    SqlInstance = 'mssql1'
    Database    = 'DatabaseAdmin'
}
Backup-DbaDatabase @backupParams

## Offload testing your backups to a second server
$testParams = @{
    SqlInstance = 'mssql1'
    Database    = "AdventureWorks2017", "DatabaseAdmin"
    Destination = 'mssql2'
    Verbose     = $true
    OutVariable = 'results'
}
Test-DbaLastBackup @testParams

## Record your backup tests into a SQL Server table
$writeParams = @{
    SqlInstance     = 'mssql1'
    Database        = 'DatabaseAdmin'
    Table           = 'TestRestore'
    AutoCreateTable = $true
}
$results | Write-DbaDataTable @writeParams

## Using Piping
Test-DbaLastBackup @testParams | Write-DbaDataTable @writeParams
