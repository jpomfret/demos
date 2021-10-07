[DscResource()]
class jpResource {
    [DscProperty(Key)]
    [string]$Key

    [DscProperty(Mandatory)]
    [String] $required

    [DscProperty(NotConfigurable)]
    [String] $ReadOnly

    [DscProperty()]
    [String] $write # no attribute - you can add value, you don't have to


    [jpResource] Get () {
        return @{
            # return current state
            Key    = $this.Key
            First  = Get-First  # this should be legit getting the thing you are configuring
            Second = Get-Second
        }
    }
    [bool] Test() {
        # validate the state of the system - using get
        $this.Get()
        return {
            $this.First -eq $current.First -and
            $this.Second -eq $current.Second
        }
    }

    [void] Set () {
        # set the state of the system
        $current = $this.Get()

        # is first set? if not set it
        if ($current.First -ne $this.First) {
            Set-First -Value $this.First
        }

        # is second set? if not set it
        if ($current.Second -ne $this.Second) {
            Set-Second -Value $this.Second
        }
    }
}

# Get, Set, Test map to Get-TargetResource,Set,Test
# Using get in both set and test will force you to have good gets!

# helper functions
# base class where we define certain helper methods to share between resources

class baseModule {
    # method so that when you import a module the verbose isn't filled with all the commands being exported
    [void] ImportModule() {
        Import-Module -Name ForMyResource -Verbose:$false
    }



}