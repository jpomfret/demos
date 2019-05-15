<#
.SYNOPSIS
Returns a specified number of ascii cats.

.DESCRIPTION
Returns a specified number of ascii cats. The default is one unless the NumberOfCats parameter is used.

.EXAMPLE
PS C:\>Get-Cat

This will get me a default of one cat.

.EXAMPLE
PS C:\>$cats = 4
PS C:\>Get-Cat -NumberOfCats $cats

Store the number of cats in a variable and then get that number of cats.

#>

function get-cat {
    param (
        [int]$NumberOfCats = 1
    )
    1..$NumberOfCats | % {
        write-host "
        |\---/|
        | o_o |
         \_^_/"
    }
}