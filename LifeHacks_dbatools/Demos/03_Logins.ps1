##############################
#                            #
#  Managing Logins & Access  #
#                            #
##############################

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

##Add-DbaServerRoleMember

##	Change password for SQL account
$pwdSplat = @{
    SqlInstance     = "mssql1"
    SqlCredential   = $credential
    Login           = "JessP"
    SecurePassword  = $securePassword
}
Set-DbaLogin @pwdSplat

## read in logins from csv?
