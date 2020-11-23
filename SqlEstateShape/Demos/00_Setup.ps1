Import-Module dbatools
Import-Module dbachecks

start-process ZoomIt.exe

#Get-Process slack -ErrorAction SilentlyContinue | Stop-Process -ErrorAction SilentlyContinue
Get-Process teams, slack -ErrorAction SilentlyContinue | Stop-Process -ErrorAction SilentlyContinue

Set-Location C:\github\demos\SqlEstateShape

docker stop mssql1, mssql2, mssql3
docker rm mssql1, mssql2, mssql3

docker-compose -f "Docker\docker-compose.yml" up -d --build

# set module path
$env:PSModulePath = "C:\Program Files\WindowsPowerShell\Modules"

$securePassword = ('Password1234!' | ConvertTo-SecureString -asPlainText -Force)
$credential = New-Object System.Management.Automation.PSCredential('sa', $securePassword)

$PSDefaultParameterValues = @{"*:SqlCredential"=$credential
                              "*:DestinationCredential"=$credential
                              "*:DestinationSqlCredential"=$credential
                              "*:SourceSqlCredential"=$credential}

Start-Sleep -Seconds (2*60)

# Clear out most of the FKs and constraints
(Get-DbaDbForeignKey -SqlInstance mssql1 -Database AdventureWorks2017 | Where-Object {$_.IsChecked -or $_.Parent.Schema -ne 'Person' }).Drop()
(Get-DbaDbCheckConstraint -SqlInstance mssql1 -Database AdventureWorks2017).Drop()

Invoke-Pester .\Tests\demo.tests.ps1
