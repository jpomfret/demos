## 1. Connect to Azure SQL Database with SQL Server authentication
$saCred = New-Object System.Management.Automation.PSCredential ('jpomfret', (ConvertTo-SecureString -String 'P@ssword1234!' -AsPlainText -Force))
Connect-DbaInstance -SqlInstance jesssqlserver7.database.windows.net -SqlCredential $saCred -OutVariable SqlDb

## 2. Connect to SQL Server on Azure VM with SQL Server authentication
$saCred = New-Object System.Management.Automation.PSCredential ('jpomfret', (ConvertTo-SecureString -String 'P@ssword1234!' -AsPlainText -Force))
Connect-DbaInstance -SqlInstance SqlOnVm.uksouth.cloudapp.azure.com -SqlCredential $saCred -OutVariable vmDb

## 3. List the databases from both instances
Get-DbaDatabase -SqlInstance $SqlDb | Format-Table ComputerName, SqlInstance, Name, Status, Owner
Get-DbaDatabase -SqlInstance $vmDb | Format-Table ComputerName, SqlInstance, Name, Status, Owner

## 4. Create a new database on the SQL Server instance on Azure VM
New-DbaDatabase -SqlInstance $vmDb -Name dbatoolsdb 

## 5. Create a table in each database
(Get-DbaDatabase -SqlInstance $SqlDb -ExcludeSystem).foreach{
    $db = $_.Name
    Write-PSFMessage -Message "Creating table in $db" 
    New-DbaDbTable -SqlInstance $SqlDb -Database $db -Name TestTable -ColumnMap @{Name='Id';Type='int'}, @{Name='InsertDate';Type='datetime'}
}
