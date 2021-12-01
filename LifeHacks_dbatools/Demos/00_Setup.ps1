Import-Module Pester -RequiredVersion 4.10.1
Import-Module dbatools
Import-Module dbachecks

start-process C:\ProgramData\chocolatey\lib\zoomit\tools\ZoomIt.exe

#Get-Process slack -ErrorAction SilentlyContinue | Stop-Process -ErrorAction SilentlyContinue
#Get-Process teams, slack -ErrorAction SilentlyContinue | Stop-Process -ErrorAction SilentlyContinue

Set-Location C:\github\demos\LifeHacks_dbatools

docker stop mssql1, mssql2
docker rm mssql1, mssql2

docker-compose -f "Docker\docker-compose.yml" up -d --build

# set module path
$env:PSModulePath = "C:\Program Files\WindowsPowerShell\Modules"

$securePassword = ('Password1234!' | ConvertTo-SecureString -asPlainText -Force)
$credential = New-Object System.Management.Automation.PSCredential('sa', $securePassword)

$PSDefaultParameterValues = @{"*:SqlCredential" = $credential
    "*:DestinationCredential"                   = $credential
    "*:DestinationSqlCredential"                = $credential
    "*:SourceSqlCredential"                     = $credential
}

Remove-Item .\masking\mssql1.AdventureWorks2017.DataMaskingConfig.json -ErrorAction SilentlyContinue
Remove-Item .\Export\* -Recurse -ErrorAction SilentlyContinue -Confirm:$false

Start-Sleep -Seconds (2 * 60)
Set-DbaSpConfigure -SqlInstance mssql1 -SqlCredential $credential -Name "clr enabled" -Value 1

Invoke-Pester .\Tests\demo.tests.ps1
