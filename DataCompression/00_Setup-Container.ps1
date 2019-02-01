Import-Module dbatools

## get config file
$path = Split-Path $MyInvocation.MyCommand.Path
$config = Import-PowerShellDataFile -Path "$path\Config.psd1"

## if container already running kill it
if ($(docker ps --filter "ancestor=jpomfret7/datacompression:demo" -a -q)) {
    write-verbose "Removing old containers"
    docker stop $(docker ps --filter "ancestor=jpomfret7/datacompression:demo" -a -q)
    docker rm $(docker ps --filter "ancestor=jpomfret7/datacompression:demo" -a -q)
}

write-verbose "Start up a container"
## start up the container with the super secret password (needs to match the dockerfile that attachs databases)
docker run -e ACCEPT_EULA=Y -e SA_PASSWORD=$($config.SAPWD) -p 1433:1433 -d jpomfret7/datacompression:demo

write-verbose "Wait for AdventureWorks to be ready"
## wait for AdventureWorks to be ready
while ($true){
    if(docker logs $(docker ps --filter "ancestor=jpomfret7/datacompression:demo" -a -q) | select-string "Database 'AdventureWorks2017' running the upgrade step from version 895 to version 896."){
        break
    }
}

Write-Output ("Running workload from {0}" -f $config.WorkloadFile)
$credential = New-Object System.Management.Automation.PSCredential('sa',($config.SAPWD | ConvertTo-SecureString -asPlainText -Force))
$null = Invoke-DbaQuery -SqlInstance $config.Instance2017 -SqlCredential $credential -Database $config.PrimaryDatabase -InputFile $config.WorkloadFile

Write-Output '-----'
Write-Output 'Go filter SSMS for sales schema'