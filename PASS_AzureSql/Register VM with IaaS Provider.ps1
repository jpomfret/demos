# https://docs.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/sql-agent-extension-manually-register-single-vm?tabs=bash%2Cazure-cli

# Get the existing  Compute VM
$vm = Get-AzVM -Name sqlOnVm -ResourceGroupName PASSdemo

# Register with SQL IaaS Agent extension in full mode
New-AzSqlVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -SqlManagementType Full -LicenseType PAYG -Location $vm.Location

<#
Name ResourceGroupName LicenseType Sku       Offer          SqlManagementType
---- ----------------- ----------- ---       -----          -----------------
jump PASSdemo         PAYG        Developer SQL2019-WS2019 Full

#>