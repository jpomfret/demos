

<#
-- SQL To create the SAS credential you use the following T-SQL
	CREATE CREDENTIAL [https://pomfretsqlbackups.blob.core.windows.net/sqlbackups]
	WITH IDENTITY='SHARED ACCESS SIGNATURE'
	, SECRET = 'SECRETHERE'
#>

Backup-DbaDatabase -SqlInstance mssql1 -Database AdventureWorks2017 -AzureBaseUrl https://pomfretsqlbackups.blob.core.windows.net/sqlbackups/ -AzureCredential pomfretAzureCred

