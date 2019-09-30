start-process C:\Temporary\ZoomIt\ZoomIt.exe

cd C:\github\demos\LifeHacks_dbatools

docker stop mssql1, mssql2
docker rm mssql1, mssql2

docker-compose -f "Docker\docker-compose.yml" up -d --build

# set module path
$env:PSModulePath = "C:\Program Files\WindowsPowerShell\Modules"

$securePassword = ('Password1234!' | ConvertTo-SecureString -asPlainText -Force)
$credential = New-Object System.Management.Automation.PSCredential('sa', $securePassword)

Remove-Item .\masking\mssql1.AdventureWorks2017.DataMaskingConfig.json -ErrorAction SilentlyContinue
Remove-Item .\Export\* -Recurse -ErrorAction SilentlyContinue -Confirm:$false

Start-Sleep -Seconds (2*60)
Set-DbaSpConfigure -SqlInstance mssql1 -SqlCredential $credential -Name "clr enabled" -Value 1

## todo
# 02
    # dbcc slow on test backups
# 03
    # read in users from csv?
# 04
    # masking with composite
# 06
    # Test-DbaBuild
# 07
    # bug exporting the second instance, nests it?
    #     Directory: C:\github\demos\LifeHacks_dbatools\Export\mssql1-09222019163407\mssql2-09222019163504
    # https://github.com/sqlcollaborative/dbatools/pull/6058 <-- PR


<#
Test-DbaTempDb
Should detect version & then not test if it's > 2016

ComputerName   : mssql2
InstanceName   : MSSQLSERVER
SqlInstance    : mssql2
Rule           : TF 1118 Enabled
Recommended    : True
CurrentSetting : False
IsBestPractice : False
Notes          : KB328551 describes how TF 1118 can benefit performance. SQL Server 2016 has this functionality enabled by default.

#>