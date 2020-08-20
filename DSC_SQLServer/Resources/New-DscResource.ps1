<#

.EXAMPLE
.\Resources\New-DscResource.ps1 -ModuleName sqlserverdsc -MinimumVersion 13.1.0.0

Creates zip and checksum for sqlserverdsc module 13.1.0.0
#>

param (
    [Parameter(Mandatory)]
    [string] $ModuleName,

    [Parameter()]
    [string] $MinimumVersion,

    [Parameter()]
    [string] $OutputPath,

    [Parameter()]
    [switch] $EnableException
)

$module = Get-Module -Name $ModuleName -ListAvailable | Where-Object {
    $_.Version -ge $MinimumVersion
}
if (-not $module) {
    Stop-PSFFunction -Message "Module $ModuleName could not be found" -EnableException $EnableException
    return
}

if (-not (Test-Path -Path $OutputPath)) {
    Stop-PSFFunction -Message "Output Path $OutputPath could not be accessed" -EnableException $EnableException
    return
}

$modulePath = Join-Path -Path $module.ModuleBase -ChildPath '*'
Write-PSFMessage -Level 'Verbose' -Message "Module Path: $modulePath"

$destinationFile = "$($module.Name)_$($module.Version).zip"
Write-PSFMessage -Level 'Verbose' -Message "Destination File: $destinationFile"

$destinationPath = Join-Path -Path $OutputPath -ChildPath $destinationFile
Write-PSFMessage -Level 'Verbose' -Message "Destination Path: $destinationPath"

$compressParams = @{
    Path = $modulePath
    DestinationPath = $destinationPath
}
Compress-Archive @compressParams

New-DscChecksum -Path $destinationPath -OutPath $OutputPath