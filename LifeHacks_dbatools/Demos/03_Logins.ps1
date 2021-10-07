##############################
#                            #
#  Managing Logins & Access  #
#                            #
##############################

# Add a Login to Server
# Add a User to Database
# Assign Permissions - Add to role
# Change Password
# Read in users from CSV

## Add Login (AD user/group)
$loginSplat = @{
    SqlInstance    = "mssql1"
    Login          = "JessP"
    SecurePassword = $securePassword
}
New-DbaLogin @loginSplat

##	Add User
$userSplat = @{
    SqlInstance = "mssql1"
    Login       = "JessP"
    Database    = "DatabaseAdmin"
}
New-DbaDbUser @userSplat

##	Add to reader role
$roleSplat = @{
    SqlInstance = "mssql1"
    User        = "JessP"
    Database    = "DatabaseAdmin"
    Role        = "db_datareader"
    Confirm     = $false
}
Add-DbaDbRoleMember @roleSplat

##Add-DbaServerRoleMember (bulkadmin, dbcreator, sysadmin)

##	Change password for SQL account
$newPassword = (Read-Host -Prompt "Enter the new password" -AsSecureString)
$pwdSplat = @{
    SqlInstance    = "mssql1"
    Login          = "JessP"
    SecurePassword = $newPassword
}
Set-DbaLogin @pwdSplat

# Read in logins from csv
## PS4+ syntax!
(Import-Csv .\users.csv).foreach{
    $server = Connect-DbaInstance -SqlInstance $psitem.Server
    New-DbaLogin -SqlInstance $server -Login $psitem.User -Password ($psitem.Password | ConvertTo-SecureString -asPlainText -Force)
    New-DbaDbUser -SqlInstance $server -Login $psitem.User -Database $psitem.Database
    Add-DbaDbRoleMember -SqlInstance $server -User $psitem.User -Database $psitem.Database -Role $psitem.Role.split(',') -Confirm:$false
}

<#
## PS Version 3 & Lower
foreach($user in $users) {
    $server = Connect-DbaInstance -SqlInstance $user.Server
    New-DbaLogin -SqlInstance $server -Login $user.User -Password ($user.Password | ConvertTo-SecureString -asPlainText -Force)
    New-DbaDbUser -SqlInstance $server -Login $user.User -Database $user.Database
    Add-DbaDbRoleMember -SqlInstance $server -User $user.User -Database $user.Database -Role $user.Role.split(',') -Confirm:$false
}
#>