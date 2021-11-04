$admincredentials = New-Object System.Management.Automation.PSCredential ('jpomfret', (ConvertTo-SecureString -String 'P@ssword1234!' -AsPlainText -force))

$admincredentials = Get-Credential

$azureSplat = @{
    SqlInstance   = 'jesssqlserver7.database.windows.net'
    SqlCredential = $admincredentials
    Database      = 'JessDb7'
}
Get-DbaDbCompression @azureSplat

<#

ComputerName    : jesssqlserver7.database.windows.net
InstanceName    :
SqlInstance     : jesssqlserver7
Database        : JessDb7
Schema          : dbo
TableName       : test
IndexName       : PK__test__357D0D3E7957D1A6
Partition       : 1
IndexID         : 1
IndexType       : ClusteredIndex
DataCompression : None
SizeCurrent     :
RowCount        : 100

#>

Test-DbaDbCompression @azureSplat

<#
WARNING: [20:45:15][Test-DbaDbCompression] Compression before SQLServer 2016 SP1 (13.0.4001.0) is only supported by enterprise, developer or evaluation edition. [jesssqlserver7.database.windows.net] has version 12.0.2000.8 and edition is SqlDatabase.
#>

Set-DbaDbCompression @azureSplat -CompressionType Page -Verbose

<#
ComputerName                  : jesssqlserver7.database.windows.net
InstanceName                  :
SqlInstance                   : jesssqlserver7
Database                      : JessDb7
Schema                        : dbo
TableName                     : test
IndexName                     :
Partition                     : 1
IndexID                       : 0
IndexType                     : ClusteredIndex
PercentScan                   :
PercentUpdate                 :
RowEstimatePercentOriginal    :
PageEstimatePercentOriginal   : 
CompressionTypeRecommendation : PAGE
SizeCurrent                   :
SizeRequested                 :
PercentCompression            :
AlreadyProcessed              : True

#>