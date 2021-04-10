
Get-DbaDatabase -SqlInstance dscsvr1 -ExcludeSystem | ft

$fileStructure = New-Object System.Collections.Specialized.StringCollection
$fileStructure.Add("C:\SQL2019\SQLData\StackOverflow2010.mdf")
$fileStructure.Add("C:\SQL2019\SQLLogs\StackOverflow2010_log.ldf")
Mount-DbaDatabase -SqlInstance dscsvr1 -Database StackOverflow2010 -FileStructure $fileStructure

Copy-DbaDatabase -Source dscsvr1 -Destination dscsvr2 -Database StackOverflow2010 -BackupRestore -SharedPath \\DscSvr1\LogShipShare

$params = @{
    SourceSqlInstance = 'dscsvr1'
    DestinationSqlInstance = 'dscsvr2'
    Database = 'StackOverflow2010'
    SharedPath= '\\DscSvr1\LogShipShare'
    CopyDestinationFolder = 
    GenerateFullBackup = $true
}
Invoke-DbaDbLogShipping @params


$engSvcAccount = 'svc-dscsvr1-eng'
$agSvcAccount = 'svc-dscsvr1-ag'

$EngSvcAccount = @{
    Name = $engSvcAccount
    UserPrincipalName = $engSvcAccount
    AccountPassword  = (Get-Credential -Credential EnterPassword).Password
    PasswordNeverExpires = $true
    Enabled = $true
}
New-AdUser @EngSvcAccount

$AgentSvcAccount = @{
    Name = $agSvcAccount 
    UserPrincipalName = $agSvcAccount 
    AccountPassword  = (Get-Credential -Credential EnterPassword).Password
    PasswordNeverExpires = $true
    Enabled = $true
}
New-AdUser @AgentSvcAccount

Get-DbaService -ComputerName dscsvr1 | ft

# grant logon as a service
Set-DbaPrivilege -ComputerName dscsvr1 -Type LPIM,IFI

Update-DbaServiceAccount -ComputerName dscsvr1 -ServiceName MSSQLSERVER -ServiceCredential (Get-Credential -Credential "Pomfret\$engSvcAccount" )
Update-DbaServiceAccount -ComputerName dscsvr1 -ServiceName SQLSERVERAGENT -ServiceCredential (Get-Credential -Credential "Pomfret\$agSvcAccount" )


$engSvcAccount = 'svc-dscsvr1-eng'  # Password1234!
$newSvcAccount = 'svc-dscsvr1-eng2' # Password1234!


Update-DbaServiceAccount -ComputerName dscsvr1 -ServiceName MSSQLSERVER -ServiceCredential (Get-Credential -Credential "Pomfret\$engSvcAccount" )
Update-DbaServiceAccount -ComputerName dscsvr1 -ServiceName MSSQLSERVER -ServiceCredential (Get-Credential -Credential "Pomfret\$newSvcAccount" )


Test-DbaSpn -ComputerName dscsvr1 | Set-DbaSpn 