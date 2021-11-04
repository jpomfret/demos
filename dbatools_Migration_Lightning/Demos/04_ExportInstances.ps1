################################
#                              #
#  Documentation for Everyone  #
#                              #
################################

# Export documentation quickly
# Use for DR scenarios
# Use to monitor environment for changes

$instanceSplat = @{
    SqlInstance   = "mssql1", "mssql2"
    Path          = '.\Export\'
    Exclude       = 'ReplicationSettings'
}
Export-DbaInstance @instanceSplat

## Compare the sp_configure files