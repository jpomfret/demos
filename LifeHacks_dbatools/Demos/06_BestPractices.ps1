#########################
#                       #
#  Meet Best Practices  #
#                       #
#########################

# Explore available test commands
# Are we patched?
# Check compatibility level
# Check owner
# Check ... everything?

Get-Command -Module dbatools -Verb Test

## Am I at the latest version? Or within 1SP of the latest version
$instanceSplat = @{
    SqlInstance   = "mssql1", "mssql2"
}
Test-DbaBuild @instanceSplat -Latest | Format-Table Build, BuildLevel, BuildTarget, Compliant
Test-DbaBuild @instanceSplat -MaxBehind 5CU | Format-Table Build, BuildLevel, BuildTarget, Compliant

Start-Process https://dbatools.io/build

"mssql1","mssql2" | Test-DbaBuild -Latest

## Test the compatibility level
Test-DbaDbCompatibility @instanceSplat |
Select-Object SqlInstance, ServerLevel, Database, DatabaseCompatibility, IsEqual |
Format-Table

## Test the database owner
Test-DbaDbOwner @instanceSplat |
Select-Object SqlInstance, Database, DBState, CurrentOwner, TargetOwner, OwnerMatch |
Format-Table

## Test the recovery model  -- default is only full?
Test-DbaDbRecoveryModel @instanceSplat |
Select-Object SqlInstance, Database, ConfiguredRecoveryModel, ActualRecoveryModel |
Format-Table

## Is my tempdb setup to meet best practices?
Test-DbaTempDbConfig @instanceSplat

## Is "max degree of parallelism" set to best practice?
#Inspired by Sakthivel Chidambaram's post about SQL Server MAXDOP Calculator (https://blogs.msdn.microsoft.com/sqlsakthi/p/maxdop-calculator),
Test-DbaMaxDop @instanceSplat

## Is Max Memory set to meet best practices?
#Inspired by Jonathan Kehayias's post about SQL Server Max memory (http://bit.ly/sqlmemcalc)
Test-DbaMaxMemory @instanceSplat |
Select-Object SqlInstance, Total, MaxValue, RecommendedValue

## Dbachecks - automate checking your estate
# https://github.com/sqlcollaborative/dbachecks
Invoke-DbcCheck -SqlInstance mssql1, mssql2 -Check DatabaseStatus