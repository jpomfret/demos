Import-Module dbatools

$config = Import-PowerShellDataFile -Path .\DataCompression\Config.psd1

## save credential - probably not recomended
$credential = New-Object System.Management.Automation.PSCredential('sa',($config.SAPWD | ConvertTo-SecureString -asPlainText -Force))

## Get Compression functions from dbatools module
Get-Command -Module dbatools -Name *Compression*

## Get help for a Function
Get-Help Get-DbaDbCompression -ShowWindow

## What should we compress - Tiger team SQL Script - 1:37 mins
$results = Test-DbaDbCompression `
-SqlInstance $config.Instance2017 `
-Database $config.PrimaryDatabase `
-SqlCredential $credential

## Let's look at the results for SalesOrderDetail
$results |
Where-Object TableName -eq 'SalesOrderDetail' |
Select-Object Schema, TableName, IndexName, IndexType, SizeCurrent, SizeRequested, CompressionTypeRecommendation

## Let's apply the suggested compression to the database
Set-DbaDbCompression `
-SqlInstance $config.Instance2017 `
-Database $config.PrimaryDatabase `
-SqlCredential $credential `
-InputObject $results

## Get current compression
Get-DbaDbCompression -SqlInstance $config.Instance2017 -Database $config.PrimaryDatabase -SqlCredential $credential |
Out-GridView

Set-DbaDbCompression `
-SqlInstance $config.Instance2017 `
-Database $config.PrimaryDatabase `
-SqlCredential $credential `
-CompressionType Row ## Page, Recommended, None
