#The Get-DscConfiguration cmdlet gets the current configuration of the nodes, if the configuration exists.
Get-DscConfiguration -CimSession DscSvr2

# Remove database - no longer in the desired state
Remove-DbaDatabase -SqlInstance DscSvr2 -Database DBA -Confirm:$false

# Now shows 'absent' - doesn't tell us we're not in the desired state
Get-DscConfiguration -CimSession DscSvr2 | Where-Object ResourceId -eq '[SqlDatabase]CreateDbaDatabase'

# detailed information about completed configuration runs on the system
Get-DscConfigurationStatus -CimSession DscSvr2

# Shows resources in desired state vs not in desired state - not acurately?
Get-DscConfigurationStatus -CimSession DscSvr2 | 
Select-Object Status, StartDate, NumberOfResources, ResourcesInDesiredState, ResourcesNotInDesiredState

# Use Test to see if we're in the desired state and to get the resources that are not
Test-DscConfiguration -CimSession DscSvr2
Test-DscConfiguration -CimSession DscSvr2 -Verbose
Test-DscConfiguration -CimSession DscSvr2 -Detailed | Select-Object ResourcesNotInDesiredState