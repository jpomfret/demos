param (
    $server = 'DSCSVR2'
)

Describe "$server LCM is ready" -Tags Lcm {
    Context "The settings are back to defaults" {
        $lcm = Get-DscLocalConfigurationManager -CimSession $server
        It "RefreshMode Should be Push" {
            $lcm.RefreshMode | Should Be "Push"
        }
        It "ActionAfterReboot Should be Continue" {
            $lcm.ActionAfterReboot | Should be "ContinueConfiguration"
        }
        It "ConfigurationModeFrequencyMins should be 15" {
            $lcm.ConfigurationModeFrequencyMins | Should be 15
        }
    }
}

Describe "$server is not configured" {
    Context "Windows features aren't installed" {
        It "NET-Framework isn't installed" {
            $features = Get-WindowsFeature -Name NET-Framework-Features -ComputerName $server
            $features.Installed | Should Be $False
        }
    }
    Context "Folders are gone" {
        $folders = Get-ChildItem "\\$server\c$\"
        It "SQL2016 folder shouldn't exist" {
                $folders.Name | Should Not Contain "SQL2016"
        }
        It "SQL2017 folder shouldn't exist" {
            $folders.Name | Should Not Contain "SQL2017"
        }
    }
    Context "SQL isn't installed" {
        It "SQL Should not be Installed" {
            $svcs = get-service -cn $server
            $svcs.Name | Should Not Contain "MSSQLSERVER"
        }
    }
    Context "No SQL Firewall rules should exist" {
        It "Firewall rules don't exist" {
            Get-NetFirewallRule -CimSession $server -DisplayName SQL* | Should Be $null
        }
    }
    Context "Output folder is empty" {
        Get-ChildItem .\output\ | Should Be $null
    }
}