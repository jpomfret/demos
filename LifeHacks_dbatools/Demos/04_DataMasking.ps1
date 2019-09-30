#########################
#                       #
#  Mask Sensitive Data  #
#                       #
#########################

# Find potentially sensitive data
# Explore randomizer
# Generate a masking config
# Mask that data

## Find sensitive data in your database
$piiSplat = @{
    SqlInstance     = "mssql1"
    SqlCredential   = $credential
    Database        = "AdventureWorks2017"
    Table           = "Employee"
}
Invoke-DbaDbPiiScan @piiSplat | Out-GridView

# Find masking types to use
Get-DbaRandomizedType | Select-Object Type -ExpandProperty type -Unique
Get-DbaRandomizedType | Select-Object Subtype -ExpandProperty Subtype -Unique

# Get types based on pattern
Get-DbaRandomizedType -Pattern "Credit"

## Generate data
Get-DbaRandomizedValue -DataType int -Min 10000
Get-DbaRandomizedValue -RandomizerType Name -RandomizerSubType FirstName  # picking from address?

Get-DbaRandomizedValue -RandomizerType address -RandomizerSubType zipcode
Get-DbaRandomizedValue -RandomizerType address -RandomizerSubType zipcode -Format '#####'

# Mask the data
## generate a file
$maskConfig = @{
    SqlInstance   = "mssql1"
    SqlCredential =  $credential
    Database      = 'AdventureWorks2017'
    Table         = "Employee"
    Column        = "NationalIDNumber", "loginid", "birthdate", "jobtitle"
    Path          = ".\masking\"
}
New-DbaDbMaskingConfig @maskConfig

## Modify the file manually

## check your file - returns nothing if good - errors if errors
Test-DbaDbDataMaskingConfig  -FilePath .\masking\masking_composite.json

# Mask the data
$maskData = @{
    SqlInstance   = "mssql1"
    SqlCredential = $credential
    Database      = "AdventureWorks2017"
    FilePath      = '.\masking\masking_composite.json'
    Confirm       = $false
}
Invoke-DbaDbDataMasking @maskData -Verbose