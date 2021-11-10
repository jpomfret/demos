# view databases
$getDbSplat = @{
    ResourceGroupName   = 'PASSdemo'
    ServerName          = 'JessSqlServer7'
}
Get-AzSqlDatabase @getDbSplat | Select-Object DatabaseName, Location, Edition, CollationName, Status, SkuName | Format-Table

# create a database
$dbSplat = @{
    ResourceGroupName   = 'PASSdemo'
    ServerName          = 'JessSqlServer7'
    DatabaseName        = 'pwshdb'
    Edition             = 'GeneralPurpose'
    Vcore               = 2
    ComputeGeneration   = 'Gen5'
}
New-AzSqlDatabase @dbSplat