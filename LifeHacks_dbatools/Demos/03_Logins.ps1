##############################
#                            #
#  Managing Logins & Access  #
#                            #
##############################

# Add a Login to Server
# Add a User to Database
# Assign Permissions - Add to role
# Change Password
# Read in users from CSV ??

## Add Login (AD user/group)
$loginSplat = @{
    SqlInstance     = "mssql1"
    SqlCredential   = $credential
    Login           = "JessP"
    SecurePassword  = $securePassword
}
New-DbaLogin @loginSplat

##	Add User
$userSplat = @{
    SqlInstance     = "mssql1"
    SqlCredential   = $credential
    Login           = "JessP"
    Database        = "DatabaseAdmin"
}
New-DbaDbUser @userSplat

##	Add to reader role
$roleSplat = @{
    SqlInstance     = "mssql1"
    SqlCredential   = $credential
    User            = "JessP"
    Database        = "DatabaseAdmin"
    Role            = "db_datareader"
    Confirm         = $false
}
Add-DbaDbRoleMember @roleSplat

##Add-DbaServerRoleMember (bulkadmin, dbcreator, sysadmin)

##	Change password for SQL account
$newPassword = (Read-Host -Prompt "Enter the new password" -AsSecureString)
$pwdSplat = @{
    SqlInstance     = "mssql1"
    SqlCredential   = $credential
    Login           = "JessP"
    SecurePassword  = $newPassword
}
Set-DbaLogin @pwdSplat

## read in logins from csv?
