Import-Module dbatools

## Get Compression functions from dbatools module
Get-Command -Module dbatools -Name *Compression*

## Get help for a Function
Get-Help Get-DbaDbCompression -ShowWindow

## What should we compress - Tiger team SQL Script
$results = Test-DbaDbCompression `
-SqlInstance localhost\sql2016 `
-Database AdventureWorks2016

## Let's look at the results for SalesOrderDetail
$results |
Where-Object TableName -eq 'SalesOrderDetail' |
Select-Object Schema, TableName, IndexName, IndexType, SizeCurrent, SizeRequested, CompressionTypeRecommendation

## Let's apply the suggested compression to the database
Set-DbaDbCompression `
-SqlInstance localhost\sql2016 `
-Database AdventureWorks2016 `
-InputObject $results

## Get current compression
Get-DbaDbCompression -SqlInstance localhost\sql2016 -Database AdventureWorks2016 | Out-GridView

Set-DbaDbCompression `
-SqlInstance localhost\sql2016 `
-Database AdventureWorks2016 `
-CompressionType Row ## Page, Recommended, None
