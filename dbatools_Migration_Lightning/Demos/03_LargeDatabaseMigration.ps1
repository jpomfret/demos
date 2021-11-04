###############################
#                             #
#  Migrate.... Big Databases  #
#                             #
###############################

# What if our databases are big
# Pre-Stage most of the data
# Downtime window for final cutover

# Get Processes
$processSplat = @{
    SqlInstance = "mssql1","mssql2"
    Database    = "AdventureWorks2017", "DatabaseAdmin"
}
Get-DbaProcess @processSplat |
    Select-Object Host, login, Program

# Kill Processes
Get-DbaProcess @processSplat | Stop-DbaProcess

# Remove database on destination
$dbSplat = @{
    SqlInstance   = "mssql2"
    ExcludeSystem = $true
}
Get-DbaDatabase @dbSplat | Remove-DbaDatabase -Confirm:$false

# Bring databases on source back online
$onlineSplat = @{
    SqlInstance   = "mssql1"
    Database      = "AdventureWorks2017","DatabaseAdmin"
    Online        = $true
}
Set-DbaDbState @onlineSplat

# before downtime - stage most of the data
$copySplat = @{
    Source          = 'mssql1'
    Destination     = 'mssql2'
    Database        = 'AdventureWorks2017'
    SharedPath      = '/sharedpath'
    BackupRestore   = $true
    NoRecovery      = $true # leave the database ready to receive more restores
    NoCopyOnly      = $true # this will break our backup chain!
}
Copy-DbaDatabase @copySplat

$diffSplat = @{
    SqlInstance = 'mssql1'
    Database    = 'AdventureWorks2017'
    Path        = '/sharedpath'
    Type        = 'Differential'
}
$diff = Backup-DbaDatabase @diffSplat

# Set the source database offline
$offlineSplat = @{
    SqlInstance = 'mssql1'
    Database    = 'AdventureWorks2017'
    Offline     = $true
    Force       = $true
}
Set-DbaDbState @offlineSplat

# restore the differential and bring the destination online
$restoreSplat = @{
    SqlInstance = 'mssql2'
    Database    = 'AdventureWorks2017'
    Path        = $diff.Path
    Continue    = $true
}
Restore-DbaDatabase @restoreSplat