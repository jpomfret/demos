###############################
#                             #
#  Script out my SQL Servers  #
#                             #
###############################

$instanceSplat = @{
    SqlInstance   = "mssql1", "mssql2"
    SqlCredential = $credential
    Path          = '.\Export\'
    Exclude       = 'ReplicationSettings'
}
Export-DbaInstance @instanceSplat

## Compare the sp_configure files