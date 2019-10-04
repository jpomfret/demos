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

Invoke-Pester .\Tests\demo.tests.ps1
