# 0 - Get the Module
    Install-Module dbachecks
    Save-Module dbachecks -Path C:\temp\dbachecks

    Import-Module dbachecks

# 1 - Check out the commands
    Get-Command -Module dbachecks

# 2 - Check out the checks
    Get-DbcCheck

    # For a specific group
    Get-DbcCheck -Group Agent

    # For a pattern
    Get-DbcCheck -Pattern *Owner*

    # For a specific check (UniqueTag)
    Get-DbcCheck -Tag DiskCapacity | Format-List

# 3 - Check out the config
    Get-DbcConfig

    # For a pattern
    Get-DbcConfig -Name skip*

    # Get a specific value
    Get-DbcConfigValue -Name policy.diskspace.percentfree

    # Set the config
    Set-DbcConfig -Name policy.diskspace.percentfree -Value 10

    # Reset the config
    Reset-DbcConfig

# 4 - Run some checks
# SqlInstance Vs ComputerName Vs Cluster
    # Single check against a single machine
    Invoke-DbcCheck -SqlInstance mssql1 -Check Databasestatus

    # Multiple checks against multiple machines
    # Only really care about the issues
    Invoke-DbcCheck -SqlInstance mssql1,mssql2 -Check Databasestatus, PageVerify -Show Fails

# 5 - The Dashboard - V1
    Invoke-DbcCheck -SqlInstance mssql1,mssql2 -Check Databasestatus, PageVerify -Passthru | 
    Update-DbcPowerBiDataSource -Environment Test
    Start-DbcPowerBi

# 6 - Store the checks in a database!
    Invoke-DbcCheck -SqlInstance mssql1,mssql2 -Check LastFullBackup -PassThru |
    Convert-DbcResult -Label 'dbachecks-Jess' |
    Write-DbcTable -SqlInstance mssql1 -Database 'DatabaseAdmin' -Table BackupChecks


    # 24:10