Configuration jpSqlFolderStructure {
    param
    (
        [String] $InstallPath,
        
        [String] $InstancePath,
        
        [String] $UserDataPath,
        
        [String] $UserLogPath,
        
        [String] $TempDbDataPath,
        
        [String] $TempDbLogPath
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    
    if($InstallPath) {
        File CreateInstallDir {
            DestinationPath = $InstallPath
            Ensure          = 'Present'
            Type            = 'Directory'
        }
    }
    if($InstancePath) {
        File CreateInstanceDir {
            DestinationPath = $InstancePath
            Ensure          = 'Present'
            Type            = 'Directory'
        }
    }
    if($UserDataPath) {
        File CreateDataDir {
            DestinationPath = $UserDataPath
            Ensure          = 'Present'
            Type            = 'Directory'
        }
    }
    if($UserLogPath) {
        File CreateLogDir {
            DestinationPath = $UserLogPath
            Ensure          = 'Present'
            Type            = 'Directory'
        }
    }
    if($TempDbDataPath) {
        File CreateTempDbData {
            DestinationPath = $TempDbDataPath
            Ensure          = 'Present'
            Type            = 'Directory'
        }
    }
    if($TempDbLogPath) {
        File CreateTempDbLogs {
            DestinationPath = $TempDbLogPath
            Ensure          = 'Present'
            Type            = 'Directory'
        }
    }
}