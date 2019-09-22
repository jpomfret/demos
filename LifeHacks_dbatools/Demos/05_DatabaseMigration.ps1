########################
#                      #
#  Database Migration  #
#                      #
########################

# migrating application databases with dbatools
# https://dbatools.io/migrating-application-dbs/

## Get databases
$datatbaseSplat = @{
    SqlInstance   = "mssql1"
    SqlCredential = $Credential
    ExcludeSystem = $true
    OutVariable   = "dbs" # OutVariable to also capture this to use later
}
Get-DbaDatabase @datatbaseSplat |
Select-Object Name, Status, RecoveryModel, Owner, Compatibility |
Format-Table

# Get Logins
$loginSplat = @{
    SqlInstance   = "mssql1"
    SqlCredential = $Credential
}
Get-DbaLogin @loginSplat |
Select-Object SqlInstance, Name, LoginType

$logins = Get-DbaLogin @loginSplat | Where-Object Name -eq 'JessP'

# Get Processes
$processSplat = @{
    SqlInstance     = "mssql1"
    SqlCredential   = $Credential
    Database        = "DatabaseAdmin"
}
Get-DbaProcess @processSplat |
Select-Object Host, login, Program

# Kill Processes
Get-DbaProcess @processSplat | Stop-DbaProcess

## Migrate the databases
$migrateDbSplat = @{
    Source                   = "mssql1"
    SourceSqlCredential      = $Credential
    Destination              = 'mssql2'
    DestinationSqlCredential = $Credential
    Database                 = $dbs.name
    BackupRestore            = $true
    SharedPath               = '/sharedpath'
    #SetSourceOffline         = $true
    Verbose                  = $true
}
Copy-DbaDatabase @migrateDbSplat

## Migrate login
$migrateLoginSplat = @{
    Source                   = "mssql1"
    SourceSqlCredential      = $Credential
    Destination              = 'mssql2'
    DestinationSqlCredential = $Credential
    Login                    = "JessP"
    Verbose                  = $true
}
Copy-DbaLogin @migrateLoginSplat

## Set source dbs offline
$offlineSplat = @{
    SqlInstance     = "mssql1"
    SqlCredential   = $Credential
    Database        = "AdventureWorks2017", "DatabaseAdmin"
    Offline         = $true
}
Set-DbaDbState @offlineSplat

## upgrade compat level & check all is ok
$compatSplat = @{
    SqlInstance = "mssql2"
    SqlCredential = $credential
}
Get-DbaDbCompatibility @compatSplat |
Select-Object SqlInstance, Database, Compatibility

$compatSplat.Add('Database','DatabaseAdmin')
$compatSplat.Add('TargetCompatibility','15')

Set-DbaDbCompatibility @compatSplat

## Upgrade database - https://thomaslarock.com/2014/06/upgrading-to-sql-server-2014-a-dozen-things-to-check/
    # Updates compatibility level
    # runs CHECKDB with data_purity
    # DBCC updateusage
    # sp_updatestats
    # sp_refreshview against all user views
$upgradeSplat = @{
    SqlInstance   = "mssql2"
    SqlCredential = $Credential
    Database      = "DatabaseAdmin"
}
Invoke-DbaDbUpgrade @upgradeSplat