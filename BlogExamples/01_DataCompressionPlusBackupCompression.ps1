
## Script to test what happens if you use data compression and backup compression
Import-Module dbatools

## 1) Restore WideWorldImporters to my local 2016 Developer edition server
    Restore-DbaDatabase -SqlInstance localhost\sql2016 `
    -Path c:\backups\WideWorldImporters-Full.bak `
    -useDestinationDefaultDirectories

## 2) Check current level of compression
    Get-DbaDbCompression -SqlInstance localhost\sql2016 `
    -Database WideWorldImporters | Group-Object DataCompression
    ## Note - there are 3 objects with ColumnStore compression, this is the default for Columnstore objects so these objects will remain at this level for all tests.

## 3) Set all row-store compression to None
    Set-DbaDbCompression -SqlInstance localhost\sql2016 `
    -Database WideWorldImporters `
    -CompressionType NONE

## 4) Check current level of compresion
    Get-DbaDbCompression -SqlInstance localhost\sql2016 `
    -Database WideWorldImporters | Group-Object DataCompression

## 5) Test 1 - Backup database Data Compression: None; Backup Compression None;
    Backup-DbaDatabase -SqlInstance localhost\sql2016 -Database WideWorldImporters `
    -BackupDirectory C:\Backups\CompressionTest -BackupFileName NoDataCompression_NoBackupCompression

## 6) Test 2 - Backup database Data Compression: None; Backup Compression On;
    Backup-DbaDatabase -SqlInstance localhost\sql2016 -Database WideWorldImporters `
    -BackupDirectory C:\Backups\CompressionTest -BackupFileName NoDataCompression_BackupCompression -CompressBackup

## 7) Set all row-store compression to Row
    Set-DbaDbCompression -SqlInstance localhost\sql2016 `
    -Database WideWorldImporters `
    -CompressionType Row

## 8) Check current level of compresion
    Get-DbaDbCompression -SqlInstance localhost\sql2016 `
    -Database WideWorldImporters | Group-Object DataCompression
    ## in this example we have some objects still showing as 'None' compression, these are memory-optimised so cannot be compressed

## 9) Test 3 - Backup database Data Compression: Row; Backup Compression None;
    Backup-DbaDatabase -SqlInstance localhost\sql2016 -Database WideWorldImporters `
    -BackupDirectory C:\Backups\CompressionTest -BackupFileName RowDataCompression_NoBackupCompression

## 10) Test 4 - Backup database Data Compression: Row; Backup Compression On;
    Backup-DbaDatabase -SqlInstance localhost\sql2016 -Database WideWorldImporters `
    -BackupDirectory C:\Backups\CompressionTest -BackupFileName RowDataCompression_BackupCompression -CompressBackup

## 11) Set all row-store compression to Row
    Set-DbaDbCompression -SqlInstance localhost\sql2016 `
    -Database WideWorldImporters `
    -CompressionType Page

## 12) Check current level of compresion
    Get-DbaDbCompression -SqlInstance localhost\sql2016 `
    -Database WideWorldImporters | Group-Object DataCompression
    ## in this example we have some objects still showing as 'None' compression, these are memory-optimised so cannot be compressed

## 13) Test 5 - Backup database Data Compression: Page; Backup Compression None;
    Backup-DbaDatabase -SqlInstance localhost\sql2016 -Database WideWorldImporters `
    -BackupDirectory C:\Backups\CompressionTest -BackupFileName PageDataCompression_NoBackupCompression

## 14) Test 6 - Backup database Data Compression: Page; Backup Compression On;
    Backup-DbaDatabase -SqlInstance localhost\sql2016 -Database WideWorldImporters `
    -BackupDirectory C:\Backups\CompressionTest -BackupFileName PageDataCompression_BackupCompression -CompressBackup

