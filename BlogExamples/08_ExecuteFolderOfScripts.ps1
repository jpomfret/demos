##################
# Some variables #
##################

$folderPath = '.\output\AdventureWorks2017'
$SqlInstance = 'mssql1'
$sourceDatabase = 'AdventureWorks2017'
$destinationDatabase = 'AdventureWorks2021'

######################################
# Setup - create a folder of scripts #
######################################

# create the output path if it doesn't exist
if (!(Test-Path $folderPath)) {
    $null = New-Item -Path $folderPath -ItemType Directory
}

# Export create statements for tables
# Using a foreach loop so we can control the name of each file separately
Get-DbaDbTable -SqlInstance $SqlInstance -Database $sourceDatabase |
ForEach-Object -PipelineVariable obj -Process { $_ } |
ForEach-Object { Export-DbaScript -InputObject $obj -FilePath ('{0}\{1}_{2}.sql' -f $folderPath, $obj.Schema, $obj.Name) }

# See how many files we have to execute
Get-ChildItem $folderPath | Measure-Object | Select-Object Count
<#
Count
-----
   71
#>

# Create a new empty database
$splatCreate = @{
    SqlInstance = $SqlInstance
    Name        = $destinationDatabase
}
New-DbaDatabase @splatCreate

# Create schemas, user defined data types and functions in new database from AdventureWorks2017
$sqlInst.Databases[$sourceDatabase].Schemas | Where-Object { -not $_.IsSystemObject }  | Export-DbaScript -Passthru  | ForEach-Object { Invoke-DbaQuery -SqlInstance $SqlInstance -Database $destinationDatabase -Query $_ }
$sqlInst.Databases[$sourceDatabase].UserDefinedDataTypes | Export-DbaScript -Passthru  | ForEach-Object { Invoke-DbaQuery -SqlInstance $SqlInstance -Database $destinationDatabase -Query $_ }
$sqlInst.Databases[$sourceDatabase].UserDefinedFunctions | Where-Object { $_.FunctionType -in ('Scalar', 'Inline') } | Export-DbaScript -Passthru  | ForEach-Object { Invoke-DbaQuery -SqlInstance $SqlInstance -Database $destinationDatabase -Query $_ }
$sqlInst.Databases[$sourceDatabase].XmlSchemaCollections | Export-DbaScript -Passthru  | ForEach-Object { Invoke-DbaQuery -SqlInstance $SqlInstance -Database $destinationDatabase -Query $_ }

###############################
# Execute a folder of scripts #
###############################

$folderPath = '.\output\AdventureWorks2017'

# Create a connection to the server that we will reuse - can use SqlCredential for alternative creds
$sqlInst = Connect-DbaInstance -SqlInstance $SqlInstance

(Get-ChildItem $folderPath).Foreach{
    Invoke-DbaQuery -SqlInstance $sqlInst -Database $destinationDatabase -File $psitem.FullName
}